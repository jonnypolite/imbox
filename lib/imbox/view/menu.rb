# frozen_string_literal: true

require 'curses'
require 'logger'

module Imbox
  module View
    # Content must be an array of objects that support
    # .id and .to_s
    class Menu
      def initialize(content, window, selection = 0)
        @content = content
        @window = window
        @selection = selection
        @range_start = 0
        @range_end = max_menu_length

        @logger = Logger.new('development.log')
      end

      def display
        y = 0
        window.clear

        content[range_start..range_end].each.with_index(range_start) do |option, index|
          window.setpos(y, 0)
          window.standout if selection == index
          window.addstr(option.to_s)
          window.standend

          y += 1
        end
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
    end
  end
end
