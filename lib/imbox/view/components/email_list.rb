# frozen_string_literal: true

require 'imbox/view/components/menu'

module Imbox
  module View
    module Components
      # Display a selectable list of emails
      # TODO: Make a parent class for common component stuff
      class EmailList
        def initialize(mailbox, parent_window, **window_config)
          @mailbox = mailbox
          @window = parent_window.subwin(
            window_config[:height],
            window_config[:width],
            window_config[:top],
            window_config[:left]
          )
          @mail_menu = Menu.new(mailbox.summary_list, window)
        end

        def draw
          mail_menu.display
          window.box
        end

        private

        attr_reader :mailbox, :mail_menu, :window
      end
    end
  end
end
