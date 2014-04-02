#!/usr/bin/env ruby
# encoding: utf-8

# File: report.rb
# Created: 25/08/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative(JacintheManagement::TABLEAU_DE_BORD_FILE)

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

      # @return [Path] pdf report file
      def self.executive_report_file
        dir = File.join(DATADIR, 'Archives')
        JacintheReports.executive_report_file(J2R_CONNECT_MODE, dir)
      end

      # build, write and send report
      # @param [Array<String>] dest destination addresses
      def self.mail_executive_report(dest = default_addresses)
        file = executive_report_file
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
  JacintheManagement::Report.mail_executive_report(%w(michel@demazure.com))

end
