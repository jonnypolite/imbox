# frozen_string_literal: true

require 'rmail'
require 'mail'
require 'imbox/mail_summary'
require 'imbox/mail_display'
require 'logger'

module Imbox
  class Mail
    def initialize(mbox_path)
      @logger = Logger.new('development.log')
      @mail_box = []
      mbox = File.open(mbox_path)

      RMail::Mailbox.parse_mbox(mbox) do |raw_email|
        parsed_email = ::Mail.read_from_string(raw_email)
        parsed_email.date = fix_date(parsed_email)
        @mail_box << parsed_email
      end

      mbox.close
    end

    def summary_list(start_range = nil, end_range = nil)
      mail_box[start_range..end_range].map.with_index(start_range) do |email, index|
        MailSummary.new(index, email)
      end
    end

    def open(id)
      # check if it's multipart or not
        # This might be as simple as looking for Content-Type: multipart
      # need some way to find all the plain/text parts
        # Each boundary marker should have a content-type
      # If there are none, then I need to do basic HTML parsing :fun:
        # I kinda remember there being a library for this
    end

    private

    attr_reader :mail_box

    def fix_date(email)
      date = email.header['received'].first.value.split(';').last.strip if email.date.nil?
      email.date.nil? ? Time.parse(date) : email.date
    end
  end
end
