package style

import "github.com/charmbracelet/lipgloss"

func BoxStyle(height int, width int, selected bool) lipgloss.Style {
	var borderColor string
	var backgroundColor string
	if selected {
		borderColor = SelectedBoxBorder
		backgroundColor = SelectedBoxBG
	} else {
		borderColor = UnselectedBoxBorder
		backgroundColor = UnselectedBoxBG
	}

	return lipgloss.NewStyle().
		BorderStyle(lipgloss.RoundedBorder()).
		BorderForeground(lipgloss.Color(borderColor)).
		Background(lipgloss.Color(backgroundColor)).
		Padding(0, 1).
		Height(height).
		Width(width - 2) // The -2 accounts for the width of the borders
}
