# frozen_string_literal: true

require 'curses'
require 'imbox/view/components/menu'
require 'imbox/view/components/confirm'
require 'imbox/view/components/email_list'
require 'imbox/view/components/email_display'
require 'logger'

module Imbox
  module View
    # This is like a main screen/page/display, on which all the other bits are rendered.
    #  Encapsulates a main Curses::Window, as well as instantiating other abstractions that
    #  handle things like listing emails by subject and displaying email bodies.
    class Display
      INPUT_CONFIG = {
        106 => 'email_list_down', # j
        107 => 'email_list_up',   # k
        112 => 'scroll_email_up', # p
        108 => 'scroll_email_down', # l
        100 => 'debug' # d
      }.freeze

      # TODO: Could there be a way for them to each manage
      # their own keyboard input bindings? I would rather define them with an associated class
      # then have everything in app.rb. I THINK the only way to do this is to have each subwindow
      # await input, will have to test.
      def initialize(mailbox)
        Curses.init_screen
        Curses.curs_set(0)
        Curses.noecho

        # Initialize all the components of the view
        @main_window = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
        @email_list = Components::EmailList.new(mailbox, main_window, **email_list_config)
        @email_display = Components::EmailDisplay.new(main_window, **email_display_config)

        @mailbox = mailbox

        draw

        @log = Logger.new('development.log')
      end

      # Runs a method if we have a corresponding
      # key in INPUT_CONFIG, sends the input back to
      # App otherwise.
      def await_input
        input = main_window.getch.ord
        # @log.debug("Key Press ord: #{input}")
        if INPUT_CONFIG.keys.include?(input)
          send(INPUT_CONFIG[input])
        else
          input
        end
      end

      def close
        Curses.close_screen unless Curses.closed?
        false
      end

      def confirm(message = nil)
        @confirm_dialog = Components::Confirm.new(main_window)
        confirm_dialog.display(message)
      end

      def draw
        email_display.update_email(mailbox.get_email(email_list.draw))
        email_display.draw

        true
      end

      def refresh
        main_window.refresh
        email_list.refresh
        email_display.refresh
      end

      def email_list_up
        email_display.update_email(mailbox.get_email(email_list.move_up))
      end

      def email_list_down
        email_display.update_email(mailbox.get_email(email_list.move_down))
      end

      def debug
        @log.debug(content_window.cury)
      end

      def scroll_email_up
        email_display.scroll_up
      end

      def scroll_email_down
        email_display.scroll_down
      end

      private

      attr_reader :confirm_dialog, :email_display, :email_list, :mailbox, :main_window

      def email_display_config
        {
          height: Curses.lines - email_list_config[:height],
          width: Curses.cols,
          top: email_list_config[:height],
          left: 0
        }
      end

      def email_list_config
        {
          height: 15,
          width: Curses.cols,
          top: 0,
          left: 0
        }
      end

      # TODO: Is this still needed? Maybe for resizing?
      def reset_main_window
        main_window.resize(Curses.lines, Curses.cols)
        main_window.clear
      end
    end
  end
end
