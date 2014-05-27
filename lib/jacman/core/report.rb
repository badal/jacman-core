#!/usr/bin/env ruby
# encoding: utf-8

# File: report.rb
# Created: 25/08/13
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheManagement
  module Core
    # building executive report and mailing it
    module Report
      MESSAGE = [
        'Message automatique.',
        'Informations concernant la situation des ventes.',
        'Se renseigner auprès du personnel pour des informations additionnelles.'
      ].join("\n")

      # @return [Array<String>] addresses to send to
      def self.default_addresses
        Defaults.defaults[:report]
      end

      # WARNING: calls j2r-core gem
      # @return [Path] pdf report file
      def self.executive_report
        require 'j2r/core/audits/tableau_de_bord.rb'
        connect_mode = 'exploitation'
        dir = File.join(DATADIR, 'Archives')
        include JacintheReports
        JacintheReports::Audits.executive_report_file(connect_mode, dir)
      end

      # build, write and send report
      # @param [Array<String>] dest destination addresses
      def self.mail_executive_report(dest = default_addresses)
        file = executive_report
        date = file.match(/.*_(.*)\.pdf/)[1]
        subject = "Tableau de bord SMF au #{date}"
        mail = Mail.new(dest, subject, MESSAGE)
        mail.attach_file(file)
        mail.send
        puts "#{file} sent to #{dest.join(', ')}"
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME

  require_relative '../core.rb'
  JacintheManagement::Core::Report.mail_executive_report(%w(michel@demazure.com))

end
