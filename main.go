package main

import (
	"fmt"
	"log"
	"net/mail"

	"github.com/alecthomas/kong"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/mailbox"
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
	emails      []mail.Message
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
		}
	}

	return m, nil
}

func (m mainModel) View() string {
	var s string

	s += lipgloss.JoinVertical(
		lipgloss.Top,
		TitleBar("Imbox", terminalWidth),
		ListBox(
			fmt.Sprintf("subject: %s", m.emails[0].Header.Get("Subject")),
			m.selectedBox == listBox,
		),
		ReadBox(
			fmt.Sprintf("width: %d", terminalWidth),
			m.selectedBox == readBox,
		),
	)

	return s
}

func main() {
	ctx := kong.Parse(&cli)
	switch ctx.Command() {
	case "open <path>":
		emails := mailbox.GetEmails(cli.Open.Path)

		p := tea.NewProgram(mainModel{selectedBox: listBox, emails: emails}, tea.WithAltScreen())

		if _, err := p.Run(); err != nil {
			log.Fatal(err)
		}

	default:
		panic(ctx.Command())
	}
}
