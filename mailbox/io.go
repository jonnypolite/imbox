package mailbox

import (
	"io"
	"net/mail"
	"os"
	"slices"

	mbox "github.com/emersion/go-mbox"
)

func GetEmails(path string) []Email {
	var emails []Email
	inbox, err := os.Open(path)
	check(err)

	mailReader := mbox.NewReader(inbox)
	for {
		rawMessage, err := mailReader.NextMessage()
		if err == io.EOF {
			break
		}
		check(err)

		msg, err := mail.ReadMessage(rawMessage)
		check(err)

		body, err := io.ReadAll(msg.Body)
		check(err)

		emails = append(emails, Email{
			Header: msg.Header,
			Body:   string(body),
		})
	}

	slices.SortFunc(emails, func(a, b Email) int {
		return a.Date().Compare(b.Date())
	})

	return emails
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}
