package main

import "github.com/charmbracelet/lipgloss"

const listBoxHeight int = 10

var (
	terminalHeight int
	terminalWidth  int
)

func ListBox(content string, selected bool) string {
	return BoxStyle(listBoxHeight, terminalWidth, selected).
		Render(content)
}

func ReadBox(content string, selected bool) string {
	return BoxStyle(readBoxHeight(), terminalWidth, selected).
		Render(content)
}

func SetTerminalSize(height int, width int) {
	terminalHeight = height
	terminalWidth = width
}

func TitleBar(titleText string, width int) string {
	return lipgloss.NewStyle().
		Width(width).
		PaddingLeft(1).
		Align(lipgloss.Left).
		Render(titleText)
}

func readBoxHeight() int {
	return terminalHeight - listBoxHeight - 5
}
