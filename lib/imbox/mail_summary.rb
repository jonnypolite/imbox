# frozen_string_literal: true

module Imbox
  class MailSummary
    DATE_FORMAT = '%m/%d/%Y %I:%M %p'

    def initialize(id, email)
      @id = id
      @date = email.date
      @from = email.from
      @subject = email.subject
    end

    attr_reader :id, :date, :from, :subject

    def to_s
      "#{date.strftime(DATE_FORMAT)} #{from.first} #{subject}"
    end
  end
end
