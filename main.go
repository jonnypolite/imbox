package main

import (
	"log"

	"github.com/alecthomas/kong"
	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/mailbox"
	"github.com/jonnypolite/imbox/ui"
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
	selectedBox box
	emails      []mailbox.Email
	summaryList ui.ScrollingList[mailbox.MailSummary]
	bodyView    ui.BodyView
}

// Init is called just before the first render
func (m mainModel) Init() tea.Cmd {
	return nil
}

func (m mainModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch message := msg.(type) {
	case tea.WindowSizeMsg:
		SetTerminalSize(message.Height, message.Width)

	case tea.KeyMsg:
		switch message.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
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

	if m.selectedBox == readBox {
		m.bodyView.Viewport, _ = m.bodyView.Viewport.Update(msg)
	}

	return m, nil
}

func (m mainModel) View() string {
	var s string
	readBoxStyle := ReadBoxStyle(m.selectedBox == readBox)

	m.bodyView.Viewport.Height = readBoxStyle.GetHeight() - 2
	m.bodyView.Viewport.Width = readBoxStyle.GetWidth() - 2

	s += lipgloss.JoinVertical(
		lipgloss.Top,
		TitleBar("Imbox", terminalWidth),
		ListBox(
			m.summaryList.Display(terminalWidth-2),
			m.selectedBox == listBox,
		),
		readBoxStyle.Render(m.bodyView.View()),
	)

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
