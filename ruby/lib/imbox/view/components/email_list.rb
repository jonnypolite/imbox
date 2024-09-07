# frozen_string_literal: true

require 'imbox/view/components/menu'
require 'logger'

module Imbox
  module View
    module Components
      # Display a selectable list of emails
      class EmailList
        def initialize(mailbox, parent_window, **window_config)
          @mailbox = mailbox
          @window = parent_window.subwin(
            window_config[:height],
            window_config[:width],
            window_config[:top],
            window_config[:left]
          )
          @mail_menu = Menu.new(mailbox.summary_list, window, boxed: true)

          @log = Logger.new('development.log')
        end

        def draw
          email_id = mail_menu.display
          window.box

          email_id
        end

        def move_down
          mail_menu.move_down
        end

        def move_up
          mail_menu.move_up
        end

        def refresh
          window.box
          window.refresh
        end

        private

        attr_reader :mailbox, :mail_menu, :window
      end
    end
  end
end
