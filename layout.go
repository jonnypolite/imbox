package main

import (
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/config"
	"github.com/jonnypolite/imbox/style"
)

const ListBoxHeight int = 10

func ListBox(content string, selected bool) string {
	return style.BoxStyle(ListBoxHeight, config.TerminalWidth, selected).
		Render(content)
}

func ReadBoxStyle(selected bool) lipgloss.Style {
	return style.BoxStyle(readBoxHeight(), config.TerminalWidth, selected)
}

func SetTerminalSize(height int, width int) {
	config.TerminalHeight = height
	config.TerminalWidth = width
}

func TitleBar(titleText string, width int) string {
	return lipgloss.NewStyle().
		Width(width).
		PaddingLeft(1).
		Align(lipgloss.Left).
		Render(titleText)
}

func readBoxHeight() int {
	return config.TerminalHeight - ListBoxHeight - 5
}
