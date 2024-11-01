package mailbox

import (
	"fmt"
	"time"
)

type MailSummary struct {
	id      int
	date    time.Time
	subject string
	from    string
}

func GetMailSummaries(emails []Email) []MailSummary {
	var summaries []MailSummary

	for i := 0; i < len(emails); i++ {
		summaries = append(summaries, MailSummary{
			i,
			emails[i].Date(),
			emails[i].Subject(),
			emails[i].From(),
		})
	}

	return summaries
}

func (ms MailSummary) ToString() string {
	return fmt.Sprintf(
		"[%s] %s: %s",
		ms.date.Format("01/02/2006 15:04"),
		ms.from,
		ms.subject,
	)
}
