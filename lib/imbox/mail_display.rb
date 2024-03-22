# frozen_string_literal: true

require 'forwardable'
require 'logger'

module Imbox
  class MailDisplay
    extend Forwardable

    # email is a Mail::Message
    def initialize(message)
      @log = Logger.new('development.log')

      @message = message

      # log_message_info
    end

    def_delegators :@message, :subject

    def body
      if message.multipart?
        message.text_part.to_s
      else
        message.body.to_s
      end
    end

    private

    attr_reader :message

    def log_message_info
      @log.debug("BOUNDARY: #{@message.boundary}")
      @log.debug("BODY_ENCODING: #{@message.body_encoding}")
      @log.debug("CONTENT_TYPE: #{@message.content_type}")
      @log.debug("MULTIPART?: #{@message.multipart?}")
      @log.debug("TEXT_PART: #{@message.text_part}") if @message.multipart?
      @log.debug("HTML_PART: #{@message.html_part}") if @message.multipart?
      @log.debug("TEXT?: #{@message.text?}")
      @log.debug("BODY: #{@message.body}") if @message.text?
      @log.debug("\n")
    end
  end
end
