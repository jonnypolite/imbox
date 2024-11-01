package main

import (
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/style"
)

const ListBoxHeight int = 10

var (
	terminalHeight int
	terminalWidth  int
)

func ListBox(content string, selected bool) string {
	return style.BoxStyle(ListBoxHeight, terminalWidth, selected).
		Render(content)
}

func ReadBoxStyle(selected bool) lipgloss.Style {
	return style.BoxStyle(readBoxHeight(), terminalWidth, selected)
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
	return terminalHeight - ListBoxHeight - 5
}
