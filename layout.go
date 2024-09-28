package main

import "github.com/charmbracelet/lipgloss"

func TitleBar(titleText string, width int) string {
	return lipgloss.NewStyle().
		Width(width).
		PaddingLeft(1).
		Align(lipgloss.Left).
		Render(titleText)
}
