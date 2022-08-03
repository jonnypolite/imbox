require 'curses'

module Imbox
  class Display
    def initialize(config = {})
      @config = config

      Curses.init_screen
      Curses.curs_set(0)
      Curses.noecho

      # Setup all the initial UI stuff
      @main = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      draw_border(main)
      draw_title(main, config[:title]) if config[:title]
      main.refresh
    end

    def await_input
      main.getch
    end

    def close
      Curses.close_screen
      false
    end

    def redraw
      main.resize(Curses.lines, Curses.cols)
      main.clear
      draw_border(main)
      draw_title(main, config[:title]) if config[:title]
      true
    end

    private

    attr_reader :config, :main

    def draw_title(window, title_text)
      window.setpos(0, 5)
      window.addstr("[ #{title_text} ]")
    end

    def draw_border(window)
      window.box
    #   # Draw the top
    #   width.times do |i|
    #     Curses.setpos(0, i)
    #     Curses.addstr('╔') if i === 0
    #     Curses.addstr('═') if i > 0 && i < width-1
    #     Curses.addstr('╗') if i === width-1
    #   end

    #   # Draw the middle vertical lines
    #   y = 1
    #   (height-2).times do
    #     Curses.setpos(y, 0)
    #     Curses.addstr('║')
    #     Curses.setpos(y, width-1)
    #     Curses.addstr('║')

    #     y += 1
    #   end

    #   # Draw the bottom
    #   width.times do |i|
    #     Curses.setpos(height, i)
    #     Curses.addstr('╚') if i === 0
    #     Curses.addstr('═') if i > 0 && i < width-1
    #     Curses.addstr('╝') if i === width-1
    #   end
    end
  end
end
