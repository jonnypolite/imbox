# frozen_string_literal: true

require 'mbox'

module Imbox
  class Mail
    def initialize(mbox_path)
      @mail_box = []

      # TODO: This never finished in irb LOL
      # Also though, it doesn't seem to be parsing the emails correctly
      # Since it's just a god damn text file I might have to split it myself and feed
      # the text into some other mail gem and see if it can read them properly.
      Mbox.open(mbox_path).each do |email|
        @mail_box << email
      end

      # Mbox doesn't really cut it. Can't parse the emails properly.
      # RMail seems to be able to, but it's cumbersome. The Message Objects that result are
      # a pain in the ass. If it's a multipart message (all the chats), then the body is always an
      # array of Message objects. Sometimes elements on that Array are ALSO arrays of Message objects!
      # Somewhere nested in that damn array is a plain text message that still needs HTML parsing to display
      # well.

      # Some code to remember
      # email_file = File.open("/Users/jseay/Downloads/mm-mail-small.mbox")
      # inbox = RMail::Mailbox.parse_mbox(email_file)
      # email_one = Mail.read_from_string(inbox[0])
      # Then I need to check if it's multipart or not
      # Then I need some say to find all the plain/text parts
      # If there are none, then I need to do basic HTML parsing :fun:
    end

    def all_subjects

    end

    private

    attr_reader :mail_box
  end
end
