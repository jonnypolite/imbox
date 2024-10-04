package mailbox

import (
	"fmt"
	"net/mail"
	"strings"
	"time"
)

type Email struct {
	mail.Message
}

func (eml Email) Date() time.Time {
	dateString := getDateString((eml.Header))

	// There is NO consistency in the date formats.
	// These are the ones I've seen so far.
	formats := [5]string{
		time.RFC1123Z,
		time.RFC1123,
		"Mon, 2 Jan 2006 15:04:05 -0700",
		"02 Jan 2006 15:04:05 -0700",
		"2 Jan 2006 15:04:05 -0700",
	}
	var err error
	var parsedTime time.Time
	// Keep trying parse formats until one hopefully works
	for i := 0; i < len(formats); i++ {
		parsedTime, err = time.Parse(formats[i], dateString)
		if err == nil {
			break
		}
	}

	return parsedTime
}

func (eml Email) From() string {
	return eml.Header.Get("From")
}

func (eml Email) Subject() string {
	var subject string

	if eml.Header.Get("X-Gmail-Labels") == "Chat" {
		name := strings.Split(eml.From(), " <")[0]
		subject = fmt.Sprintf("Chat with %s", name)
	} else {
		subject = eml.Header.Get("Subject")
	}

	return subject
}

// Helper functions
func getDateString(header mail.Header) string {
	if received, ok := header["Received"]; ok {
		firstReceived := received[len(received)-1]
		return strings.Split(strings.Split(firstReceived, "; ")[1], " (")[0]
	}

	return strings.Split(header["Date"][0], " (")[0]
}
