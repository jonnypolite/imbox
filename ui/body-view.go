package ui

import (
	"github.com/charmbracelet/bubbles/viewport"
	"github.com/jonnypolite/imbox/mailbox"
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
	return bv.Viewport.View()
}
