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
          initialize_body_range_values

          @log = Logger.new('development.log')
        end

        def draw
          window.clear
          window.box
          if @email
            # TODO draw_header info
            draw_body
          end
          window.refresh
        end

        # This takes a MailReader
        def update_email(email)
          initialize_body_range_values
          @email = email
        end

        def scroll_up
          return unless @body_range_start.positive?

          @body_range_start -= 1
          @body_range_end -= 1
        end

        def scroll_down
          return unless body_range_end < body_lines.length

          @body_range_start += 1
          @body_range_end += 1
        end

        def refresh
          draw
        end

        private

        attr_reader :body_range_start, :body_range_end, :email, :window

        def body_lines
          email.body.split("\n")
        end

        def draw_body
          body_lines[body_range_start..body_range_end].each_with_index do |line, i|
            window.setpos(i + 1, 2)
            window.addstr(line)
          end
        end

        def initialize_body_range_values
          @body_range_start = 0
          @body_range_end = window.maxy - 3
        end
      end
    end
  end
end
