# frozen_string_literal: true

require 'forwardable'

module Imbox
  class MailDisplay
    extend Forwardable

    def initialize(email)
      @email = email
      @body = email.body.split!(email.boundary)
    end

    def_delegators :@email, :subject

    # This doesn't need to be in to_s necessarily
    def to_s
      @body.parts[0].to_s
    end
  end
end
