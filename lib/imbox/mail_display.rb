# frozen_string_literal: true

module Imbox
  class MailDisplay
    def initialize(email)
      @email = email
    end

    def to_s
      "email content!"
    end
  end
end
