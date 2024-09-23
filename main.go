package main

import (
	"fmt"
	"log"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type selectedWindow uint

const (
	listView selectedWindow = iota
	readView
)

var (
	terminalWidth    int
	terminalHeight   int
	listWindowHeight int = 10
)

type mainModel struct {
	window selectedWindow
}

func windowStyle(width int) lipgloss.Style {
	return lipgloss.NewStyle().
		Width(width - 2). // The -2 accounts for the width of the borders
		BorderStyle(lipgloss.RoundedBorder())
}

func listWindowStyle(height int, width int) lipgloss.Style {
	return lipgloss.NewStyle().
		Height(height).
		Inherit(windowStyle(width))
}

func emailWindowStyle(width int) lipgloss.Style {
	return lipgloss.NewStyle().
		Height(terminalHeight - listWindowHeight - 4).
		Inherit(windowStyle(width))
}

func (m mainModel) Init() tea.Cmd {
	// This might open up the .mbox file at some point
	return nil
}

func (m mainModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch message := msg.(type) {
	case tea.WindowSizeMsg:
		terminalWidth = message.Width
		terminalHeight = message.Height

	case tea.KeyMsg:
		switch message.String() {
		case "q":
			return m, tea.Quit
		}
	}

	return m, nil
}

func (m mainModel) View() string {
	var s string

	s += lipgloss.JoinVertical(
		lipgloss.Top,
		listWindowStyle(listWindowHeight, terminalWidth).Render(fmt.Sprintf("height: %d", terminalHeight)),
		emailWindowStyle(terminalWidth).Render(fmt.Sprintf("width: %d", terminalWidth)),
	)

	return s
}

func main() {
	p := tea.NewProgram(mainModel{window: listView}, tea.WithAltScreen())

	if _, err := p.Run(); err != nil {
		log.Fatal(err)
	}
}
