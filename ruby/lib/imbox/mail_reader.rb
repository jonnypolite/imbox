# frozen_string_literal: true

require 'forwardable'
require 'html_to_plain_text'
require 'logger'

module Imbox
  class MailReader
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
        if !message.text_part.to_s.empty?
          clean_up_text_part(message.text_part)
        else
          clean_up_html_part(message.html_part)
        end
      else
        clean_up_body(message.body)
      end
    end

    private

    attr_reader :message

    def clean_up_body(body)
      body.to_s.clean_slash_r
    end

    def clean_up_text_part(text_part)
      text_part
        .to_s
        .clean_slash_r
        .gsub(/=0D/, '')
        .clean_header_stuff
    end

    def clean_up_html_part(html_part)
      # The library that parses the HTML seems to leave behind a bunch of shit
      # that I try to clear out manually with all the regex.
      HtmlToPlainText
        .plain_text(html_part.to_s)
        .gsub(/= /, '')
        .gsub(/<\/?\w+>/i, '')
        .gsub(/(span|div)>/i, '')
        .gsub(/&nbsp;/i, '')
        .gsub(/<span.*?>/i, '')
        .gsub(/=\n/, "\n")
        .clean_header_stuff
    end

    def log_message_info
      @log.debug("BOUNDARY: #{@message.boundary}")
      @log.debug("BODY_ENCODING: #{@message.body_encoding}")
      @log.debug("CONTENT_TYPE: #{@message.content_type}")
      @log.debug("MULTIPART?: #{@message.multipart?}")
      @log.debug("TEXT_PART: #{@message.text_part}") if @message.multipart?
      @log.debug("TEXT_PART EMPTY?: #{@message.text_part.to_s.empty?}") if @message.multipart?
      @log.debug("HTML_PART: #{@message.html_part}") if @message.multipart?
      @log.debug("TEXT?: #{@message.text?}")
      @log.debug("BODY: #{@message.body}") if @message.text?
      @log.debug("\n")
    end
  end
end

class String
  def clean_header_stuff
    self
      .gsub(/content-type: .*?\s/i, '')
      .gsub(/content-transfer-encoding: .*?\s/i, '')
      .gsub(/charset=.*?\s/i, '')
  end

  def clean_slash_r
    self
      .gsub(/\r/, '')
  end
end
