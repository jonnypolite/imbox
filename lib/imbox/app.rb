require 'imbox/screen'

module Imbox
  class App
    def self.call(mbox_path)
      new(mbox_path)
    end

    INPUT_CONFIG = {
      113 => 'quit'
    }

    def initialize(mbox_path)
      @mail_box = Mbox.open(mbox_path)

      run
    end

    private

    attr_reader :screen

    def run
      @screen = Screen.new('Imbox')

      loop do
        # update content

        input = screen.await_input

        continue = self.send(INPUT_CONFIG[input.ord] || "noop")

        break unless continue
      end
    end

    def quit
      screen.close
      false
    end

    def noop
      true
    end
  end
end
