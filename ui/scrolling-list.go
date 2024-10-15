package ui

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

type Stringable interface {
	ToString() string
}

type ScrollingList[T Stringable] struct {
	Items         []T
	RangeStart    int
	BoxHeight     int
	SelectedIndex int
}

func (sl *ScrollingList[T]) Display(maxWidth int) string {
	var itemStrings []string
	var text string
	var rangeEnd int

	if sl.RangeStart+sl.BoxHeight >= len(sl.Items) {
		rangeEnd = len(sl.Items) - 1
	} else {
		rangeEnd = sl.RangeStart + sl.BoxHeight
	}

	for i := sl.RangeStart; i <= rangeEnd; i++ {
		displayString := truncateIfNecessary(sl.Items[i].ToString(), maxWidth)
		if i == sl.SelectedIndex {
			text = lipgloss.NewStyle().
				Background(lipgloss.Color("99")).
				Render(displayString)
		} else {
			text = displayString
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

	if sl.SelectedIndex > sl.RangeStart+sl.BoxHeight {
		sl.RangeStart++
	}
}

func truncateIfNecessary(str string, maxWidth int) string {
	if maxWidth > 0 && len(str) >= maxWidth-2 {
		return fmt.Sprintf("%s...", str[0:maxWidth-8])
	}

	return str
}
