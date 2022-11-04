# frozen_string_literal: true

def expect_a_subwindow_to_be_created(height, width)
  expect(parent_window).to receive(:subwin).with(
    height,
    width,
    (parent_window_maxy / 2) - 5,
    (parent_window_maxx / 2) - (width / 2)
  )
end

def expect_a_default_confirm_title
  expect(dialog_window).to receive(:clear)
  expect(dialog_window).to receive(:setpos).with(2, 1)
  expect(dialog_window).to receive(:addstr).with(
    Strings.align(
      Strings.wrap('Are you sure?', dialog_width - 2),
      dialog_width - 2,
      direction: :center
      )
    )
end

def expect_a_button_to_be_drawn(text, indent, bottom_padding, standout)
  expect(dialog_window).to receive(:setpos).with(dialog_height - bottom_padding, indent)
  expect(dialog_window).to receive(:addstr).with(described_class::BUTTON_OUTLINE)
  expect(dialog_window).to receive(:setpos).with(dialog_height - (bottom_padding + 1), indent)
  expect(dialog_window).to receive(:standout) if standout
  expect(dialog_window).to receive(:addstr).with(Strings.align(text, described_class::BUTTON_OUTLINE.length, direction: :center))
  expect(dialog_window).to receive(:standend)
  expect(dialog_window).to receive(:setpos).with(dialog_height - (bottom_padding + 2), indent)
  expect(dialog_window).to receive(:addstr).with(described_class::BUTTON_OUTLINE)
end

def expect_the_final_dialog_setup
  expect(dialog_window).to receive(:box)
  expect(dialog_window).to receive(:refresh)
  expect(dialog_window).to receive(:close)
end

describe Imbox::View::Confirm do
  subject { described_class.new(parent_window) }

  let(:parent_window) { instance_spy('Curses::Window') }
  let(:parent_window_maxy) { 100 }
  let(:parent_window_maxx) { 100 }
  let(:dialog_height) { described_class::MAX_DIALOG_HEIGHT }
  let(:dialog_width) { described_class::MAX_DIALOG_WIDTH }

  let(:dialog_window) { instance_double('Curses::Window') }

  before do
    allow(parent_window).to receive(:maxy).and_return(parent_window_maxy)
    allow(parent_window).to receive(:maxx).and_return(parent_window_maxx)
    allow(dialog_window).to receive(:getch).and_return("\n")
  end

  context 'when displaying a confirm dialog' do
    context 'when the parent window height and width are above the dialog maximums' do
      it 'uses the dialog maximum height and width' do
        expect_a_subwindow_to_be_created(dialog_height, dialog_width)
          .and_return(dialog_window)

        expect_a_default_confirm_title

        expect_a_button_to_be_drawn('CANCEL', 7, 2, true)
        expect_a_button_to_be_drawn(
          'OK',
          dialog_width - 7 - described_class::BUTTON_OUTLINE.length,
          2,
          false
        )

        expect_the_final_dialog_setup

        subject.display
      end
    end

    context 'when the parent window height and width are below the dialog maximums' do
      let(:parent_window_maxy) { 9 }
      let(:parent_window_maxx) { 50 }
      let(:dialog_height) { parent_window_maxy }
      let(:dialog_width) { parent_window_maxx }

      it 'uses the parent window maximum height and width' do
        expect_a_subwindow_to_be_created(dialog_height, dialog_width)
          .and_return(dialog_window)

        expect_a_default_confirm_title

        expect_a_button_to_be_drawn('CANCEL', 7, 2, true)
        expect_a_button_to_be_drawn(
          'OK',
          dialog_width - 7 - described_class::BUTTON_OUTLINE.length,
          2,
          false
        )

        expect_the_final_dialog_setup

        subject.display
      end
    end
  end
end
