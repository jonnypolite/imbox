package ui

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
)

type Stringable interface {
	ToString() string
}

type ScrollingList[T Stringable] struct {
	Items         []T
	RangeStart    int
	Size          int
	SelectedIndex int
}

func (sl *ScrollingList[T]) Display() string {
	var itemStrings []string
	var text string
	var rangeEnd int
	if sl.RangeStart+sl.Size >= len(sl.Items) {
		rangeEnd = len(sl.Items) - 1
	} else {
		rangeEnd = sl.RangeStart + sl.Size
	}

	for i := sl.RangeStart; i <= rangeEnd; i++ {
		if i == sl.SelectedIndex {
			text = lipgloss.NewStyle().
				Background(lipgloss.Color("99")).
				Render((sl.Items[i].ToString()))
		} else {
			text = sl.Items[i].ToString()
		}
		itemStrings = append(itemStrings, text)
	}
	return strings.Join(itemStrings, "\n")
}

func (sl *ScrollingList[T]) Up() {
	if sl.SelectedIndex > 0 {
		sl.SelectedIndex--
	}

	if sl.SelectedIndex < sl.RangeStart {
		sl.RangeStart--
	}
}

func (sl *ScrollingList[T]) Down() {
	if sl.SelectedIndex < len(sl.Items)-1 {
		sl.SelectedIndex++
	}

	if sl.SelectedIndex > sl.RangeStart+sl.Size {
		sl.RangeStart++
	}
}
