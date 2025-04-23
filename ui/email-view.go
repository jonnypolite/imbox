package ui

import (
	"fmt"

	"github.com/charmbracelet/bubbles/viewport"
	"github.com/charmbracelet/lipgloss"
	"github.com/jonnypolite/imbox/mailbox"
	"github.com/jonnypolite/imbox/style"
)

type EmailView struct {
	email    mailbox.Email
	Viewport viewport.Model
}

func (ev *EmailView) SetEmail(email mailbox.Email) {
	// Keep track of the email so we can skip all this
	// if the incoming email is the same one.
	// TODO: return if email == bv.Email (need some way to check equality)
	// CAN WE OVERLOAD THE == OPERATOR FOR OUR EMAIL STRUCT?!
	ev.email = email

	// load it into the viewport
	ev.Viewport.SetContent(email.Body)
	ev.Viewport.GotoTop()
}

func (bv *EmailView) View() string {
	return lipgloss.JoinVertical(
		lipgloss.Top,
		bv.Header(),
		bv.Viewport.View(),
		bv.Footer(),
	)
}

func (ev EmailView) Header() string {
	headerStyle := lipgloss.NewStyle().
		Border(lipgloss.ThickBorder(), false, false, true).
		BorderForeground(lipgloss.Color(style.UnselectedBoxBorder)).
		Align(lipgloss.Left).
		Width(ev.Viewport.Width)

	return headerStyle.Render("here is the header\nhere is some more")
}

func (ev EmailView) HeaderHeight() int {
	return 3
}

func (ev EmailView) FooterHeight() int {
	return 2
}

func (ev EmailView) Footer() string {
	percentDisplay := ev.Viewport.ScrollPercent() * 100

	footerStyle := lipgloss.NewStyle().
		Border(lipgloss.ThickBorder(), true, false, false).
		BorderForeground(lipgloss.Color(style.UnselectedBoxBorder)).
		Align(lipgloss.Right).
		Width(ev.Viewport.Width)

	percentage := fmt.Sprintf("%3.f%%", percentDisplay)

	return footerStyle.Render(percentage)
}
