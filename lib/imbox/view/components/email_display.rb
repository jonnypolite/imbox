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
            # draw_header
            # draw_body
            window.setpos(1, 2)
            window.addstr(email.body)
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
