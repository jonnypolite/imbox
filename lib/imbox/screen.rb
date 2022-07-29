require 'curses'
require 'tty-screen'

module Imbox
  class Screen
    def initialize(title)
      @width = TTY::Screen.width
      @height = TTY::Screen.height

      Curses.init_screen
      Curses.curs_set(0)
      Curses.noecho

      draw_window
      draw_title(title)

      Curses.refresh
    end

    def update_content(content)
      # content will be an array of strings?
      # each one will get its own line in the content area within the box
    end

    def await_input
      Curses.getch
    end

    def close
      Curses.close_screen
    end

    private

    attr_reader :height, :width

    def draw_title(title_text)
      Curses.setpos(0, 5)
      Curses.addstr("[ #{title_text} ]")
    end

    def draw_window
      # Example
      # ╔ ═ ╗
      # ║   ║
      # ╚ ═ ╝

      # Draw the top
      width.times do |i|
        Curses.setpos(0, i)
        Curses.addstr('╔') if i === 0
        Curses.addstr('═') if i > 0 && i < width-1
        Curses.addstr('╗') if i === width-1
      end

      # Draw the middle vertical lines
      y = 1
      (height-2).times do
        Curses.setpos(y, 0)
        Curses.addstr('║')
        Curses.setpos(y, width-1)
        Curses.addstr('║')

        y += 1
      end

      # Draw the bottom
      width.times do |i|
        Curses.setpos(height, i)
        Curses.addstr('╚') if i === 0
        Curses.addstr('═') if i > 0 && i < width-1
        Curses.addstr('╝') if i === width-1
      end
    end
  end
end
