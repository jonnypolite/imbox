package ui

import "strings"

type Stringable interface {
	ToString() string
}

type Menu[T Stringable] struct {
	Items      []T
	RangeStart int
	Size       int
}

func (m Menu[T]) Display() string {
	var itemStrings []string

	for _, value := range m.Items[m.RangeStart:m.Size] {
		itemStrings = append(itemStrings, value.ToString())
	}
	return strings.Join(itemStrings, "\n")
}

func (m Menu[T]) up() {

}

func (m Menu[T]) down() {

}
