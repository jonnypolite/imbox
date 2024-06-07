# frozen_string_literal: true

require 'curses'
require 'imbox/view/components/menu'
require 'imbox/view/components/confirm'
require 'imbox/view/components/email_list'
require 'imbox/view/components/email_display'
require 'logger'

module Imbox
  module View
    class Display
      INPUT_CONFIG = {
        106 => 'email_list_down', # j
        107 => 'email_list_up',   # k
        # 10 => 'open_email', # return
        # 127 => 'exit_email', # backspace
        # 112 => 'scroll_email_up', # p
        # 108 => 'scroll_email_down', # l
        100 => 'debug' # d
      }.freeze

      # TODO: I think what I want Display to be is a wrapper/manager for a collection of Curses
      # windows. They would be placed next to each other in a cohesive way and registered here.
      # They would be initialized and positioned here sort of like Vue components. I guess there would
      # still have to be a main_window for them to sit on. Could there be a way for them to each manage
      # their own keyboard input bindings? I would rather define them with an associated class
      # then have everything in app.rb. I THINK the only way to do this is to have each subwindow
      # await input, will have to test.
      def initialize(mailbox)
        Curses.init_screen
        Curses.curs_set(0)
        Curses.noecho

        # Initialize all the components of the view
        @main_window = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
        @email_list = Components::EmailList.new(mailbox, main_window, **email_list_config)
        @email_display = Components::EmailDisplay.new(main_window, **email_display_config)

        @selected_email_id = nil
        @mailbox = mailbox

        draw

        @log = Logger.new('development.log')
      end

      # Runs a method if we have a corresponding
      # key in INPUT_CONFIG, sends the input back to
      # app otherwise.
      def await_input
        input = main_window.getch.ord
        @log.debug("Key Press ord: #{input}")
        if INPUT_CONFIG.keys.include?(input)
          send(INPUT_CONFIG[input])
        else
          input
        end
      end

      def close
        Curses.close_screen unless Curses.closed?
        false
      end

      def confirm(message = nil)
        @confirm_dialog = Components::Confirm.new(main_window)
        confirm_dialog.display(message)
      end

      def draw
        # reset_main_window
        @selected_email_id = email_list.draw
        email_display.update(mailbox.get_email(@selected_email_id))
        email_display.draw

        true
      end

      def refresh
        main_window.refresh
        email_list.refresh
      end

      # This receives a list of MailSummary objects
      # def show_menu_content(content)
      #   @mail_menu ||= Menu.new(content, content_window)
      #   mail_id = mail_menu.display

      #   content_window.refresh

      #   mail_id
      # end

      def show_email_content(email_id)
        # This returns a MailDisplay
        # mailbox.get_email(@selected_email_id)
        # content_window.clear

        # Scroll stuff?
        # content_window.setscrreg(0, 10)

        content_window.setpos(0, 0)
        content_window.addstr(email.body)
        # content_window.scrollok(true)
      end

      def email_list_up
        @selected_email_id = email_list.move_up
      end

      def email_list_down
        @selected_email_id = email_list.move_down
      end

      def debug
        @log.debug(content_window.cury)
      end

      # def scroll_email_up
      #   content_window.scrl(1)
      # end

      # def scroll_email_down
      #   content_window.scrl(-1)
      # end

      private

      attr_reader :confirm_dialog, :email_display, :email_list, :mailbox, :main_window

      def email_display_config
        {
          height: Curses.lines - email_list_config[:height],
          width: Curses.cols,
          top: email_list_config[:height],
          left: 0
        }
      end

      def email_list_config
        {
          height: 15,
          width: Curses.cols,
          top: 0,
          left: 0
        }
      end

      # def draw_header(window)
      #   width = window.maxx - 2

      #   if header_window.nil?
      #     @header_window = window.subwin(HEADER_HEIGHT, width, 1, 1)
      #   else
      #     header_window.clear
      #     header_window.resize(HEADER_HEIGHT, width)
      #   end

      #   bottom_border(header_window)
      #   header_window.setpos(0, 0)
      #   header_window.addstr('Header placeholder text.')
      # end

      # def draw_content_window(window)
      #   height = window.maxy - HEADER_HEIGHT - 2
      #   width = window.maxx - 2
      #   top = HEADER_HEIGHT + 1
      #   left = 1

      #   if content_window.nil?
      #     @content_window ||= window.subwin(height, width, top, left)
      #   else
      #     content_window.resize(height, width)
      #   end
      # end

      # def draw_title(window, title_text)
      #   window.setpos(0, 5)
      #   window.addstr("[ #{title_text} ]")
      # end

      # def bottom_border(window)
      #   window.setpos(window.maxy - 1, 0)
      #   (0..window.maxx).each do
      #     window.addstr('─')
      #   end
      # end

      def reset_main_window
        main_window.resize(Curses.lines, Curses.cols)
        main_window.clear
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
