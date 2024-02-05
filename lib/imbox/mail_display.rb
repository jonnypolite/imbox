# frozen_string_literal: true

module Imbox
  class MailDisplay
    def initialize(email)
      @email = email
    end

    # This doesn't need to be in to_s necessarily
    def to_s
      "email content!"
    end
  end
end
