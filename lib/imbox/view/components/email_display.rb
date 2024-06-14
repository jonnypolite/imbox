# frozen_string_literal: true

require 'logger'

module Imbox
  module View
    module Components
      class EmailDisplay
        def initialize(parent_window, **window_config)
          @window = parent_window.subwin(
            window_config[:height],
            window_config[:width],
            window_config[:top],
            window_config[:left]
          )

          @email = nil

          @log = Logger.new('development.log')
        end

        def draw
          window.clear
          window.box
          if @email
            # TODO draw_header info
            # draw_body
            email.body.split("\n").each_with_index do |line, i|
              window.setpos(i + 1, 2)
              window.addstr(line)
            end
          end
        end

        # This takes a MailReader
        def update(email)
          @email = email
        end

        def refresh
          window.refresh
        end

        private

        attr_reader :email, :window
      end
    end
  end
end
