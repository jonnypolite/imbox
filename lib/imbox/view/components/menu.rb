# frozen_string_literal: true

require 'logger'

module Imbox
  module View
    module Components
      # Content must be an array of objects that support
      # .id and .to_s
      class Menu
        def initialize(content, window, selection = 0)
          @content = content
          @window = window
          @selection = selection
          @range_start = 0
          @range_end = max_menu_length

          @log = Logger.new('development.log')
        end

        def display
          y = 0
          window.clear

          content[range_start..range_end].each.with_index(range_start) do |option, index|
            window.setpos(y, 2)
            window.standout if selection == index
            window.addstr(truncate(option.to_s))
            window.standend

            y += 1
          end

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

        def max_menu_length
          window.maxy - 1
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
