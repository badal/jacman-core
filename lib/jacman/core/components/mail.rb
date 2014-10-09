#!/usr/bin/env ruby
# encoding: utf-8

# File: mail.rb
# Created: 20/08/13
#
# by Michel Demazure, from an example found on the web

# Script methods for JacintheManagement
module JacintheManagement
  module Core
    MAIL_MODE[:from] = Defaults.defaults[:from]

    # for automatic message and file sending
    class Mail
      # @param [Array<String>] dest destination addresses
      # @param [String] subject subject of mail
      # @return [String] header of message
      # @param [String] to addresses appearing in header
      def self.header(dest, subject, to)
        header = <<HEADER_END
Content-Type: multipart/mixed; boundary=#{MARKER}
MIME-Version: 1.0
Subject: #{subject}
From: #{MAIL_MODE[:from]}
TO: #{to}

HEADER_END
        header
      end

      # @param [String] message content of mail
      # @return [String] encoded message
      # @param [String] type type of text ('plain', 'html')
      def self.message_part(message, type)
        part = <<MESSAGE_END
--#{MARKER}
Content-Type: text/#{type} ; charset=UTF-8
Content-Transfer-Encoding: 8bit
#{message}

MESSAGE_END
        part
      end

      MARKER = 'AUNIQUEMARKER'

      # @param [String] message content of mail
      # @param [Array<String>] dest destination addresses
      # @param [String] subject subject of mail
      # @param [String] to addresses appearing in header
      # @param [String] type type of text ('plain', 'html')
      def initialize(dest, subject, message, type = 'plain', to = Array(dest).join(',') )
        @dest = dest
        @header = Mail.header(dest, subject, to)
        @message_part = Mail.message_part(message, type)
        @attached = []
      end

      # @param [Path] path path of file to be attached
      def attach_file(path)
        # Read the file and encode it into base64 format
        file_content = File.read(path)
        encoded_content = [file_content].pack('m') # base64
        filename = File.basename(path)
        to_attach = <<ATTACHEMENT_END
--#{MARKER}
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="#{filename}"
#{encoded_content}
ATTACHEMENT_END
        @attached << to_attach
      end

      # @return [String] packed content to send
      def packed
        packed = @header + @message_part
        @attached.each do |attached|
        packed += attached
        end
        packed + "--#{MARKER}--"
      end

      # Send the mail
      def send
        Net::SMTP.start(MAIL_MODE[:server], 25) do |smtp|
          smtp.send_message(packed, MAIL_MODE[:from], @dest)
        end
      end

      # Fake sending the mail for tests
      def demo
        "------------ mail content ----------\n" +
            @header + @message_part +
            '------------ end of mail ------------'
      end

      def essai
        @attached
      end
    end
  end
end

