# frozen_string_literal: true

require 'imbox/display'
require 'imbox/mail'

module Imbox
  class App
    INPUT_CONFIG = {
      113 => 'exit_loop',
      Curses::KEY_RESIZE => 'on_terminal_resize'
    }.freeze

    def self.call(mbox_path)
      new(mbox_path)
    end

    def initialize(mbox_path)
      @mail = Mail.new(mbox_path)

      run
    end

    private

    attr_reader :display, :mail

    def run
      @display = Display.new(title: 'Imbox')

      loop do
        summary = mail.summary_list.map(&:to_s).join("\n")
        display.set_content(summary)

        input = display.await_input

        continue = send(INPUT_CONFIG[input.ord] || 'noop')

        break unless continue
      end
    ensure
      quit
    end

    def on_terminal_resize
      display.redraw
    end

    def exit_loop
      false
    end

    def quit
      display.close
    end

    def noop
      true
    end
  end
end
