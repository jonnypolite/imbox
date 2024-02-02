# frozen_string_literal: true

require 'logger'
require 'strings'

module Imbox
  module View
    class Confirm
      MAX_DIALOG_WIDTH = 60
      MAX_DIALOG_HEIGHT = 10
      BUTTON_OUTLINE = '--------'
      INPUT_CONFIG = {
        9 => 'toggle_selection', # tab
        10 => 'make_selection' # enter
        # Curses::KEY_RESIZE => 'on_terminal_resize' Maybe a nice to have?
      }.freeze

      def initialize(parent_window)
        @parent_window = parent_window
        @output = false

        @logger = Logger.new('development.log')
      end

      def display(message = 'Are you sure?')
        top = (parent_window.maxy / 2) - 5
        left = (parent_window.maxx / 2) - (width / 2)
        @confirm_dialog = parent_window.subwin(height, width, top, left)
        confirm_dialog.clear

        # Confirm message
        confirm_dialog.setpos(2, 1)
        confirm_dialog.addstr(
          Strings.align(
            Strings.wrap(message, width - 2),
            width - 2,
            direction: :center
          )
        )

        # OK and cancel
        draw_cancel(standout: true)
        draw_ok

        confirm_dialog.box
        confirm_dialog.refresh

        loop do
          input = confirm_dialog.getch
          continue = send(INPUT_CONFIG[input.ord] || 'noop')
          break unless continue

          confirm_dialog.refresh
        end

        confirm_dialog.close

        @output
      end

      private

      attr_reader :confirm_dialog, :parent_window

      def draw_cancel(standout: false)
        indent = 7
        bottom_padding = 2

        draw_button('CANCEL', indent, bottom_padding, standout)
      end

      def draw_ok(standout: false)
        indent = 7
        bottom_padding = 2

        draw_button('OK', width - indent - BUTTON_OUTLINE.length, bottom_padding, standout)
      end

      def draw_button(text, indent, bottom_padding, standout)
        confirm_dialog.setpos(height - bottom_padding, indent)
        confirm_dialog.addstr(BUTTON_OUTLINE)
        confirm_dialog.setpos(height - (bottom_padding + 1), indent)
        confirm_dialog.standout if standout
        confirm_dialog.addstr(Strings.align(text, BUTTON_OUTLINE.length, direction: :center))
        confirm_dialog.standend
        confirm_dialog.setpos(height - (bottom_padding + 2), indent)
        confirm_dialog.addstr(BUTTON_OUTLINE)
      end

      def height
        if parent_window.maxy <= MAX_DIALOG_HEIGHT
          parent_window.maxy
        else
          MAX_DIALOG_HEIGHT
        end
      end

      def width
        if parent_window.maxx <= MAX_DIALOG_WIDTH
          parent_window.maxx
        else
          MAX_DIALOG_WIDTH
        end
      end

      # input handling
      def toggle_selection
        @output = !@output
        draw_ok(standout: @output)
        draw_cancel(standout: !@output)

        true
      end

      def make_selection
        false # Just breaking the loop inside display
      end

      def noop
        true
      end
    end
  end
end
