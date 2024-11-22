package ui

import (
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/style"
)

type Confirm struct {
	confirmText   string
	yesText       string
	noText        string
	selection     bool
	selectionMade bool
}

func NewConfirm(confirmText, yesText, noText string) (c Confirm) {
	c.confirmText = confirmText
	c.yesText = yesText
	c.noText = noText
	c.selection = false
	c.selectionMade = false

	return c
}

// Creates and returns the string that is the
// rendered view of the confirm box.
func (c Confirm) View() string {
	var yesButton, noButton string

	if c.selection {
		yesButton = style.ActiveButtonStyle.Render(c.yesText)
		noButton = style.ButtonStyle.Render(c.noText)
	} else {
		yesButton = style.ButtonStyle.Render(c.yesText)
		noButton = style.ActiveButtonStyle.Render(c.noText)
	}
	question := lipgloss.NewStyle().
		Align(lipgloss.Center).
		Render(c.confirmText)

	buttons := lipgloss.JoinHorizontal(lipgloss.Top, yesButton, noButton)
	content := lipgloss.JoinVertical(lipgloss.Center, question, buttons)

	return style.ConfirmBoxStyle.Render(content)
}

// Returns two booleans: the first is whether the selection was made, the
// second is the selection itself (true for yes, false for no).
func (c *Confirm) Update(msg tea.Msg) (bool, bool) {
	switch message := msg.(type) {
	case tea.KeyMsg:
		switch message.String() {
		case "tab":
			c.selectionMade = false
			c.selection = !c.selection
		case "enter":
			c.selectionMade = true
		}
	}

	return c.selectionMade, c.selection
}
