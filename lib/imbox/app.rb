# frozen_string_literal: true

require 'imbox/view/display'
require 'imbox/mailbox'
require 'logger'

module Imbox
  class App
    INPUT_CONFIG = {
      113 => 'exit', # q
      Curses::KEY_RESIZE => 'on_terminal_resize'
    }.freeze

    def self.call(mbox_path)
      new(mbox_path)
    end

    def initialize(mbox_path)
      @mailbox = Mailbox.new(mbox_path)
      @selected_email_id = nil
      @log = Logger.new('development.log')

      run
    end

    private

    attr_reader :display, :mailbox

    def run
      @display = View::Display.new(mailbox)

      loop do
        input = display.await_input
        continue = send(INPUT_CONFIG[input] || 'noop')
        break unless continue

        display.refresh
      end
    ensure
      display.close
    end

    # def list_emails
    #   summary = mailbox.summary_list
    #   @selected_email_id = display.show_menu_content(summary)
    # end

    def open_email
      display.show_email_content(mailbox.get_email(@selected_email_id))
      true
    end

    def exit_email
      list_emails
      true
    end

    def move_up
      @selected_email_id = display.menu_up
    end

    def move_down
      @selected_email_id = display.menu_down
    end

    def on_terminal_resize
      display.draw
    end

    def exit
      confirm = display.confirm("Are you sure you'd like to quit?")
      display.draw

      # Confirm returns true on OK, false on CANCEL
      # but false is the thing that will break the input loop
      !confirm
    end

    def noop
      true
    end
  end
end
