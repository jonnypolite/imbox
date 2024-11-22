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

var ConfirmBoxStyle = lipgloss.NewStyle().
	BorderStyle(lipgloss.DoubleBorder()).
	BorderForeground(lipgloss.Color(SelectedBoxBorder)).
	Height(5).
	Width(35).
	Align(lipgloss.Center)

var ButtonStyle = lipgloss.NewStyle().
	Foreground(lipgloss.Color("#FFF7DB")).
	Background(lipgloss.Color("#888B7E")).
	Padding(1, 3).
	Margin(2)

var ActiveButtonStyle = ButtonStyle.
	Foreground(lipgloss.Color(ButtonSelectedFG)).
	Background(lipgloss.Color(ButtonSelectedBG)).
	Underline(true)
