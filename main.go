package main

import (
	"net/http"
	"time"

	tea "github.com/charmbracelet/bubbletea"
)

const url = "https://charm.sh"

type model struct {
	status int
	err    error
}

func checkServer() tea.Msg {

	// Create an HTTP client and make a GET request.
	c := &http.Client{Timeout: 10 * time.Second}
	res, err := c.Get(url)

	if err != nil {
		// There was an error making our request. Wrap the error we received
		// in a message and return it.
		return errMsg{err}
	}
	// We received a response from the server. Return the HTTP status code
	// as a message.
	return statusMsg(res.StatusCode)
}

type statusMsg int

type errMsg struct{ err error }

// For messages that contain errors it's often handy to also implement the
// error interface on the message.
func (e errMsg) Error() string { return e.err.Error() }

func main() {
	// weeeeeeee
}
