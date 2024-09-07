package main

import tea "github.com/charmbracelet/bubbletea"

type selectedWindow uint

const (
	listView selectedWindow = iota
	readView
)

type mainModel struct {
	window selectedWindow
}

// func newModel() mainModel {
// 	m := mainModel{window: listView}
// 	return m
// }

func main() {
	p := tea.NewProgram(mainModel{window: listView}, tea.WithAltScreen())
}
