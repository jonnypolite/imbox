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
          @body_range_start = 0
          @body_range_end = window.maxy - 3

          @log = Logger.new('development.log')
        end

        def draw
          window.clear
          window.box
          if @email
            # TODO draw_header info
            draw_body
          end
        end

        # This takes a MailReader
        def update_email(email)
          @email = email
        end

        def scroll_up
        end

        def scroll_down
          return unless body_range_end < body_lines.length

          @body_range_start += 1
          @body_range_end += 1
        end

        def refresh
          window.refresh
        end

        private

        attr_reader :body_range_start, :body_range_end, :email, :window

        def body_lines
          email.body.split("\n")
        end

        def draw_body
          body_lines[body_range_start..body_range_end].each.with_index(body_range_start) do |line, i|
            window.setpos(i + 1, 2)
            window.addstr(line)
          end
        end
      end
    end
  end
end
