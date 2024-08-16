# frozen_string_literal: true

require 'logger'

module Imbox
  module View
    module Components
      # Content must be an array of objects that support
      # .id and .to_s
      class Menu
        def initialize(content, window, boxed: false)
          @content = content
          @window = window
          @boxed = boxed
          @selection = 0
          @range_start = 0
          @range_end = max_menu_length

          @log = Logger.new('development.log')
        end

        def display
          y = @boxed ? 1 : 0
          window.clear
          window.box if @boxed

          content[range_start..range_end].each.with_index(range_start) do |option, index|
            window.setpos(y, 2)
            window.standout if selection == index
            window.addstr(truncate(option.to_s))
            window.standend

            y += 1
          end

          draw_scrollbar
          selection
        end

        def move_up
          @selection -= 1 unless selection.zero?
          if selection < range_start
            @range_start -= 1
            @range_end -= 1
          end

          display
        end

        def move_down
          @selection += 1 unless selection == content.length - 1
          if selection > range_end
            @range_start += 1
            @range_end += 1
          end

          display
        end

        def update
          @range_end = range_start + max_menu_length
        end

        private

        attr_reader :content, :range_start, :range_end, :selection, :window

        def draw_scrollbar
          # ▐ This is the thick line that I want to represent the scrollbar

          # Decide if we need a scrollbar. Is there more content than rows?
          return unless content.length > window.maxy

          scroll_y = scrollbar_top
          (1..scrollbar_size).each do
            window.setpos(scroll_y, window.maxx - 1)
            window.addstr('▐')
            scroll_y += 1
          end
        end

        # Decide how big the scrollbar should be based on window size and content size
        # mimimum size = 2, max = 75% of window rows
        def scrollbar_size
          viewable_percentage = window.maxy.to_f / content.length
          (viewable_percentage * window.maxy).floor.clamp(2, window.maxy * 0.75)
        end

        def scrollbar_top
          rows_unseen = (content.length - range_end) - 1
          # get rows_unseen% of the total? Maybe that's a number that gets closer
          # and closer to zero that we can add scrollbar size to?

          1
        end

        def max_menu_length
          @boxed ? window.maxy - 3 : window.maxy - 1
        end

        # Despite the name, this will only truncate if necessary
        def truncate(item_str)
          if item_str.length > (window.maxx - 3)
            clip = window.maxx - 10
            "#{item_str[0..clip]}..."
          else
            item_str
          end
        end
      end
    end
  end
end
