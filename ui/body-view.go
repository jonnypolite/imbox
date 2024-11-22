package ui

import (
	"fmt"

	"github.com/charmbracelet/bubbles/viewport"
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/mailbox"
	"github.com/jonnypolite/imbox/style"
)

type BodyView struct {
	email    mailbox.Email
	Viewport viewport.Model
}

func (bv *BodyView) SetEmail(email mailbox.Email) {
	// Keep track of the email so we can skip all this
	// if the incoming email is the same one.
	// TODO: return if email == bv.Email (need some way to check equality)
	// CAN WE OVERLOAD THE == OPERATOR FOR OUR EMAIL STRUCT?!
	bv.email = email

	// load it into the viewport
	bv.Viewport.SetContent(email.Body)
	bv.Viewport.GotoTop()
}

func (bv *BodyView) View() string {
	return lipgloss.JoinVertical(lipgloss.Top, bv.Viewport.View(), bv.footer())
}

func (bv BodyView) footer() string {
	percentDisplay := bv.Viewport.ScrollPercent() * 100

	footerStyle := lipgloss.NewStyle().
		BorderStyle(lipgloss.RoundedBorder()).
		BorderForeground(lipgloss.Color(style.UnselectedBoxBorder)).
		Align(lipgloss.Right).
		Width(bv.Viewport.Width - 2)

	percentage := fmt.Sprintf("%3.f%%", percentDisplay)

	return footerStyle.Render(percentage)
}
