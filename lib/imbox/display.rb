# frozen_string_literal: true

require 'curses'

module Imbox
  class Display
    HEADER_HEIGHT = 5

    def initialize(config = {})
      @config = config

      Curses.init_screen
      Curses.curs_set(0)
      Curses.noecho

      @main_window = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      redraw

      main_window.refresh
    end

    def await_input
      main_window.getch
    end

    def close
      Curses.close_screen unless Curses.closed?
      false
    end

    def redraw
      main_window.resize(Curses.lines, Curses.cols)
      main_window.clear
      main_window.box
      draw_title(main_window, config[:title]) if config[:title]
      draw_header(main_window)
      draw_content_window(main_window)
      true
    end

    def set_content(content, menu = false)
      y = 0
      content_window.setpos(y, 0)
      content.split(/\r?\n/) do |line|
        content_window.addstr(line)
        y += 1
        content_window.setpos(y, 0)
      end
      content_window.refresh
    end

    private

    attr_reader :config, :main_window, :content_window

    def draw_header(window)
      header_window = window.subwin(HEADER_HEIGHT, window.maxx - 2, 1, 1)
      bottom_border(header_window)
      header_window.setpos(0, 0)
      header_window.addstr('I figure stuff will go in here like mail count, and a control reference.')
    end

    def draw_content_window(window)
      height = window.maxy - HEADER_HEIGHT - 2
      width = window.maxx - 2
      top = HEADER_HEIGHT + 1
      left = 1

      @content_window = window.subwin(height, width, top, left)
    end

    def draw_title(window, title_text)
      window.setpos(0, 5)
      window.addstr("[ #{title_text} ]")
    end

    def bottom_border(window)
      # logger = Logger.new("development.log")

      window.setpos(window.maxy - 1, 0)
      (0..window.maxx).each do
        window.addstr('─')
      end
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
