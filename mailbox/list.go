package mailbox

import (
	"net/mail"
	"slices"
	"time"
)

type mailSummary struct {
	id      int
	date    time.Time
	subject string
}

func GetSummaryList(emails []mail.Message, rangeStart int, rangeEnd int) []mailSummary {
	var summaries []mailSummary

	for i := 0; i < len(emails); i++ {
		date, _ := emails[i].Header.Date()
		subject := emails[i].Header.Get("subject")
		summaries = append(summaries, mailSummary{i, date, subject})
	}

	slices.SortFunc(summaries, func(a, b mailSummary) int {
		return a.date.Compare(b.date)
	})

	return summaries
}
