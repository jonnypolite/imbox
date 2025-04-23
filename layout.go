package main

import (
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/config"
	"github.com/jonnypolite/imbox/style"
)

func ListBox(content string, selected bool) string {
	return style.BoxStyle(style.ListBoxHeight, config.TerminalWidth, selected).
		Render(content)
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
