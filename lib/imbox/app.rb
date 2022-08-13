require 'imbox/display'

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
      @mail_box = Mbox.open(mbox_path)

      run
    end

    private

    attr_reader :display

    def run
      begin
        @display = Display.new(:title => 'Imbox')

        loop do
          # update content

          input = display.await_input

          continue = self.send(INPUT_CONFIG[input.ord] || "noop")

          break unless continue
        end
      ensure
        quit
      end
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
