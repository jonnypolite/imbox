require 'tty-spinner'

module Imbox
  class App
    def self.call(mbox_path)
      new(mbox_path)
    end

    def initialize(mbox_path)
      spinner = TTY::Spinner.new("[:spinner] Loading mail ...", success_mark: "✔")
      spinner.auto_spin
      @mail_box = Mbox.open(mbox_path)
      spinner.success("done.")

      puts "There are apparently #{@mail_box.length} emails in that .mbox file."
    end
  end
end
