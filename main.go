package main

import (
	"fmt"
	"log"

	"github.com/alecthomas/kong"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var cli struct {
	Open struct {
		Path string `arg:"" help:"Path to your .mbox file." type:"path"`
	} `cmd:"" help:"Browse the contents of an .mbox file."`
}

type window uint

const (
	listWindow window = iota
	readWindow
)

const numberOfWindows = 2

var (
	terminalWidth       int
	terminalHeight      int
	listWindowHeight    int = 10
	selectedWindowStyle     = lipgloss.NewStyle().
				BorderForeground(lipgloss.Color("#22df5e"))
)

type mainModel struct {
	selectedWindow window
}

func windowStyle(width int, selected bool) lipgloss.Style {
	style := lipgloss.NewStyle().
		Width(width - 2). // The -2 accounts for the width of the borders
		BorderStyle(lipgloss.ThickBorder()).
		BorderForeground(lipgloss.Color("#157e36"))

	if selected {
		return selectedWindowStyle.Inherit(style)
	}

	return style
}

func listWindowStyle(height int, width int, selected bool) lipgloss.Style {
	return lipgloss.NewStyle().
		Height(height).
		Inherit(windowStyle(width, selected))
}

func emailWindowStyle(width int, selected bool) lipgloss.Style {
	return lipgloss.NewStyle().
		Height(terminalHeight - listWindowHeight - 4).
		Inherit(windowStyle(width, selected))
}

// Init is called just before the first render
func (m mainModel) Init() tea.Cmd {
	// This will open up the .mbox file at some point
	return nil
}

func (m mainModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch message := msg.(type) {
	case tea.WindowSizeMsg:
		terminalWidth = message.Width
		terminalHeight = message.Height

	case tea.KeyMsg:
		switch message.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "tab":
			m.selectedWindow = (m.selectedWindow + 1) % numberOfWindows
		}
	}

	return m, nil
}

func (m mainModel) View() string {
	var s string

	s += lipgloss.JoinVertical(
		lipgloss.Top,
		listWindowStyle(listWindowHeight, terminalWidth, m.selectedWindow == listWindow).Render(fmt.Sprintf("selectedWindow: %d", m.selectedWindow)),
		emailWindowStyle(terminalWidth, m.selectedWindow == readWindow).Render(fmt.Sprintf("width: %d", terminalWidth)),
	)

	return s
}

func main() {
	ctx := kong.Parse(&cli)
	switch ctx.Command() {
	case "open <path>":
		p := tea.NewProgram(mainModel{selectedWindow: listWindow}, tea.WithAltScreen())

		if _, err := p.Run(); err != nil {
			log.Fatal(err)
		}

	default:
		panic(ctx.Command())
	}
}
