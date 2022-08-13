# frozen_string_literal: true

require 'curses'

module Imbox
  class Display
    def initialize(config = {})
      @config = config

      Curses.init_screen
      Curses.curs_set(0)
      Curses.noecho

      @main = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      redraw

      main.refresh
    end

    def await_input
      main.getch
    end

    def close
      Curses.close_screen unless Curses.closed?
      false
    end

    def redraw
      main.resize(Curses.lines, Curses.cols)
      main.clear
      main.box
      draw_title(main, config[:title]) if config[:title]
      draw_header(main)
      true
    end

    private

    attr_reader :config, :main

    def draw_header(window)
      header = window.subwin(5, window.maxx - 2, 1, 1)
      bottom_border(header)
      window.setpos(2, 2)
      window.addstr('I figure stuff will go in here like mail count, and a control reference.')
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
