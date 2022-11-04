# frozen_string_literal: true

require 'imbox/view/display'
require 'imbox/mail'
require 'logger'

module Imbox
  class App
    INPUT_CONFIG = {
      106 => 'move_down', # j
      107 => 'move_up',   # k
      113 => 'exit_loop', # q
      Curses::KEY_RESIZE => 'on_terminal_resize'
    }.freeze

    def self.call(mbox_path)
      new(mbox_path)
    end

    def initialize(mbox_path)
      @mail = Mail.new(mbox_path)
      @logger = Logger.new('development.log')

      run
    end

    private

    attr_reader :display, :mail

    def run
      @display = View::Display.new(title: 'Imbox')
      summary = mail.summary_list
      display.show_content(summary, menu: true)

      loop do
        input = display.await_input
        continue = send(INPUT_CONFIG[input.ord] || 'noop')
        break unless continue

        display.refresh
      end
    ensure
      quit
    end

    def move_up
      display.menu_up
    end

    def move_down
      display.menu_down
    end

    def on_terminal_resize
      display.redraw
    end

    def exit_loop
      confirm = display.confirm("Are you sure you'd like to quit?")
      display.redraw

      # Confirm returns true on OK, false on CANCEL
      # but false is the thing that will break the input loop
      !confirm
    end

    def quit
      display.close
    end

    def noop
      true
    end
  end
end
