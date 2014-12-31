#!/usr/bin/env ruby
# encoding: utf-8

# File: mail.rb, created 31/12/14
#
# (c) Michel Demazure

module JacintheManagement
  # Methods for e-subscriptions notification
  module Core
    # delivery method
    ::Mail.defaults do
      delivery_method :smtp, address: MAIL_MODE[:server]
    end

    class SmfMail < ::Mail::Message
      MAIL_MODE = Conf.mail_mode
      MAIL_MODE[:from] = Core::Defaults.defaults[:from]

      # @param [String] message content of mail
      # @param [Array<String>] dest destination addresses
      # @param [String] subject subject of mail
      def initialize(dest, subject, content)
        super()
        add_content(content)
        self.to = Array(dest).join(',')
        self.from = MAIL_MODE[:from]
        self.subject = subject
      end

      # @param [String] content content in utf-8
      def add_content(content)
        self.text_part = ::Mail::Part.new do
          content_type 'text/plain; charset=UTF-8'
          body content
        end
      end

      # send the mail
      def send
        deliver!
      end

      # useless, for compatibility
      def demo
        to_s
      end
    end
  end
end

