# frozen_string_literal: true

require 'curses'
require 'imbox/view/menu'
require 'logger'

module Imbox
  module View
    class Display
      CONTENT_SPLIT_REGEX = /\r?\n/
      HEADER_HEIGHT = 5

      def initialize(config = {})
        @config = config

        Curses.init_screen
        Curses.curs_set(0)
        Curses.noecho

        @main_window = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
        redraw

        main_window.refresh

        @logger = Logger.new('development.log')
      end

      def await_input
        main_window.getch
      end

      def close
        Curses.close_screen unless Curses.closed?
        false
      end

      def redraw
        reset_main_window
        draw_title(main_window, config[:title]) if config[:title]
        draw_header(main_window)
        draw_content_window(main_window)
        mail_menu&.update
        mail_menu&.display
        true
      end

      def refresh
        content_window.refresh
        main_window.refresh
      end

      def content(content, menu: false)
        if menu
          add_menu_content(content)
        else
          add_basic_content(content)
        end

        content_window.refresh
      end

      def menu_up
        mail_menu.move_up
        true
      end

      def menu_down
        mail_menu.move_down
        true
      end

      private

      attr_reader :config, :header_window, :main_window, :content_window, :mail_menu

      def draw_header(window)
        width = window.maxx - 2

        if header_window.nil?
          @header_window = window.subwin(HEADER_HEIGHT, width, 1, 1)
        else
          header_window.clear
          header_window.resize(HEADER_HEIGHT, width)
        end

        bottom_border(header_window)
        header_window.setpos(0, 0)
        header_window.addstr('Header placeholder text.')
      end

      def draw_content_window(window)
        height = window.maxy - HEADER_HEIGHT - 2
        width = window.maxx - 2
        top = HEADER_HEIGHT + 1
        left = 1

        if content_window.nil?
          @content_window ||= window.subwin(height, width, top, left)
        else
          content_window.resize(height, width)
        end

        content_window.setscrreg(0, height)
      end

      def draw_title(window, title_text)
        window.setpos(0, 5)
        window.addstr("[ #{title_text} ]")
      end

      def bottom_border(window)
        window.setpos(window.maxy - 1, 0)
        (0..window.maxx).each do
          window.addstr('─')
        end
      end

      def add_basic_content(content)
        y = 0
        content_window.setpos(y, 0)
        content.split(CONTENT_SPLIT_REGEX) do |line|
          content_window.addstr(line)
          y += 1
          content_window.setpos(y, 0)
        end
      end

      def add_menu_content(content)
        @mail_menu ||= Menu.new(content, content_window)
        mail_menu.display
      end

      def reset_main_window
        main_window.resize(Curses.lines, Curses.cols)
        main_window.clear
        main_window.box
      end

      # def border(window)
      #   # Draw the top
      #     Curses.addstr('╔') if i === 0
      #     Curses.addstr('═') if i > 0 && i < width-1
      #     Curses.addstr('╗') if i === width-1

      #   # Draw the middle vertical lines
      #     Curses.addstr('║')

      #   # Draw the bottom
      #     Curses.addstr('╚') if i === 0
      #     Curses.addstr('═') if i > 0 && i < width-1
      #     Curses.addstr('╝') if i === width-1
      # end
    end
  end
end
