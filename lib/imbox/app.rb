require 'imbox/display'

module Imbox
  class App
    def self.call(mbox_path)
      new(mbox_path)
    end

    INPUT_CONFIG = {
      113 => 'quit',
      Curses::KEY_RESIZE => 'on_terminal_resize'
    }

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

    def quit
      display.close
    end

    def noop
      true
    end
  end
end
