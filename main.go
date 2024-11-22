package main

import (
	"log"

	"github.com/alecthomas/kong"
	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/config"
	"github.com/jonnypolite/imbox/mailbox"
	"github.com/jonnypolite/imbox/style"
	"github.com/jonnypolite/imbox/ui"
	"github.com/jonnypolite/imbox/ui/helpers"
)

var cli struct {
	Open struct {
		Path string `arg:"" help:"Path to your .mbox file." type:"path"`
	} `cmd:"" help:"Browse the contents of an .mbox file."`
}

type box uint

const (
	listBox box = iota
	readBox
)

const numberOfBoxes = 2

type mainModel struct {
	selectedBox   box
	emails        []mailbox.Email
	summaryList   ui.ScrollingList[mailbox.MailSummary]
	bodyView      ui.BodyView
	dialogVisible bool
	dialog        ui.Confirm
}

// Init is called just before the first render
func (m mainModel) Init() tea.Cmd {
	return nil
}

func (m *mainModel) showConfirm(confirmText, yesText, noText string) {
	m.dialog = ui.NewConfirm(confirmText, yesText, noText)
	m.dialogVisible = true
}

// Updates the model. Executes every time there is an action
// like a key press.
func (m mainModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch message := msg.(type) {
	case tea.WindowSizeMsg:
		SetTerminalSize(message.Height, message.Width)

	case tea.KeyMsg:
		if m.dialogVisible {
			selectionMade, selection := m.dialog.Update(msg)
			if selectionMade {
				if selection {
					return m, tea.Quit
				}
				m.dialogVisible = false
			}
		} else if m.selectedBox == readBox {
			switch message.String() {
			case "ctrl+c", "q":
				m.showConfirm("Are you sure you want to quit?", "Yes", "No")
			case "tab":
				m.selectedBox = (m.selectedBox + 1) % numberOfBoxes
			default:
				m.bodyView.Viewport, _ = m.bodyView.Viewport.Update(msg)
			}
		} else {
			switch message.String() {
			case "ctrl+c", "q":
				m.showConfirm("Are you sure you want to quit?", "Yes", "No")
			case "tab":
				m.selectedBox = (m.selectedBox + 1) % numberOfBoxes
			case "j":
				if m.selectedBox == listBox {
					m.bodyView.SetEmail(m.emails[m.summaryList.Down()])
				}
			case "k":
				if m.selectedBox == listBox {
					m.bodyView.SetEmail(m.emails[m.summaryList.Up()])
				}
			}
		}
	}

	return m, nil
}

// View builds the complicated string that is the UI.
func (m mainModel) View() string {
	var s string
	readBoxStyle := ReadBoxStyle(m.selectedBox == readBox)

	m.bodyView.Viewport.Height = readBoxStyle.GetHeight() - 2
	m.bodyView.Viewport.Width = readBoxStyle.GetWidth() - 2

	s += lipgloss.JoinVertical(
		lipgloss.Top,
		TitleBar("Imbox", config.TerminalWidth),
		ListBox(
			m.summaryList.Display(config.TerminalWidth-2),
			m.selectedBox == listBox,
		),
		readBoxStyle.Render(m.bodyView.View()),
	)

	if m.dialogVisible {
		return helpers.PlaceOverlay(
			(config.TerminalWidth/2)-(style.ConfirmBoxStyle.GetWidth()/2),
			10,
			m.dialog.View(),
			s,
		)
	}

	return s
}

func main() {
	ctx := kong.Parse(&cli)
	switch ctx.Command() {
	case "open <path>":
		emails := mailbox.GetEmails(cli.Open.Path)
		summaryList := ui.ScrollingList[mailbox.MailSummary]{
			Items:         mailbox.GetMailSummaries(emails),
			RangeStart:    0,
			BoxHeight:     ListBoxHeight - 1,
			SelectedIndex: 0,
		}
		// Viewport width and height are just placeholder values.
		// They will get reset before displaying.
		bodyView := ui.BodyView{Viewport: viewport.New(5, 5)}
		bodyView.SetEmail(emails[0])

		model := mainModel{
			selectedBox: listBox,
			emails:      emails,
			summaryList: summaryList,
			bodyView:    bodyView,
		}

		p := tea.NewProgram(model, tea.WithAltScreen())

		if _, err := p.Run(); err != nil {
			log.Fatal(err)
		}

	default:
		panic(ctx.Command())
	}
}
