package main

import "github.com/charmbracelet/lipgloss"

func BoxStyle(height int, width int, selected bool) lipgloss.Style {
	var borderColor string
	if selected {
		borderColor = "#22df5e"
	} else {
		borderColor = "#a9aaab"
	}

	return lipgloss.NewStyle().
		BorderStyle(lipgloss.RoundedBorder()).
		BorderForeground(lipgloss.Color(borderColor)).
		Padding(1).
		Height(height).
		Width(width - 2) // The -2 accounts for the width of the borders
}
