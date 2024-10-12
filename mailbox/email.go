package mailbox

import (
	"net/mail"
	"strings"
	"time"
)

type Email struct {
	mail.Message
}

func (eml Email) Date() time.Time {
	received := eml.Header["Received"][len(eml.Header["Received"])-1]
	receivedTime := strings.Split(strings.Split(received, "; ")[1], " (")[0]

	// There is NO consistency in the date formats.
	// These are the ones I've seen so far.
	formats := [3]string{
		time.RFC1123Z,
		"Mon, 2 Jan 2006 15:04:05 -0700",
		"02 Jan 2006 15:04:05 -0700",
	}
	var err error
	var parsedTime time.Time
	// Keep trying parse formats until one hopefully works
	for i := 0; i < len(formats); i++ {
		parsedTime, err = time.Parse(formats[i], receivedTime)
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
	return eml.Header.Get("Subject")
}
