# frozen_string_literal: true

require 'rmail'
require 'mail'
require 'imbox/mail_summary'
require 'imbox/mail_display'
require 'logger'

module Imbox
  class Mailbox
    def initialize(mbox_path)
      @logger = Logger.new('development.log')
      @emails = []
      mbox = File.open(mbox_path)

      RMail::Mailbox.parse_mbox(mbox) do |raw_email|
        parsed_email = ::Mail.read_from_string(raw_email)
        parsed_email.date = fix_date(parsed_email)
        @emails << parsed_email
      end

      mbox.close
    end

    def summary_list(start_range = nil, end_range = nil)
      emails[start_range..end_range].map.with_index(start_range) do |email, index|
        MailSummary.new(index, email)
      end
    end

    def get_email(id)
      MailDisplay.new(emails[id])
    end

    private

    attr_reader :emails

    def multipart?(email)
      logger.debug(email)
    end

    def fix_date(email)
      date = email.header['received'].first.value.split(';').last.strip if email.date.nil?
      email.date.nil? ? Time.parse(date) : email.date
    end
  end
end
