package mailbox

import (
	"io"
	"net/mail"
	"os"

	mbox "github.com/emersion/go-mbox"
)

func GetEmails(path string) []mail.Message {
	var emails []mail.Message
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

		emails = append(emails, *msg)
	}

	return emails
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}
