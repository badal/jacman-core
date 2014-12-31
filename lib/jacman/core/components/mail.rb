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
      # marker
      MARKER = 'SMFmarkerforautomaticmail'
      END_MARKER = "--#{MARKER}--\n"

      # @param [String] subject subject of mail
      # @return [String] header of message
      # @param [Object] dest addresses
      def self.header(dest, subject)
        to = Array(dest).join(',')
        header = <<HEADER_END
Content-Type: multipart/mixed; boundary=#{MARKER}
MIME-Version: 1.0
Date: #{Time.now.to_date.rfc822}
Subject: #{subject}
From: #{MAIL_MODE[:from]}
TO: #{to}

--#{MARKER}
HEADER_END
        header
      end

      # @param [String] message content of mail
      # @return [String] encoded message
      def self.message_part(message)
        part = <<MESSAGE_END
Content-Type: text/plain ; charset=UTF-8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
#{message}

MESSAGE_END
        part
      end


      # @param [String] message content of mail
      # @param [Array<String>] dest destination addresses
      # @param [String] subject subject of mail
      def initialize(dest, subject, message)
        @dest = dest
        @header = Mail.header(dest, subject)
        @message_part = Mail.message_part(message)
        @attached = nil
      end

      # @param [Path] path path of file to be attached
      def attach_file(path)
        # Read the file and encode it into base64 format
        file_content = File.read(path)
        encoded_content = [file_content].pack('m') # base64
        filename = File.basename(path)

        @attached = <<ATTACHEMENT_END
--#{MARKER}

Content-Type: application/octet-stream
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="#{filename}"
#{encoded_content}
ATTACHEMENT_END
      end

      # @return [String] packed content to send
      def packed
        packed = @header + @message_part
        packed += @attached if @attached
        packed + END_MARKER
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
          packed +
          '------------ end of mail ------------'
      end
    end
  end
end
