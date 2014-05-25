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

      # TODO: all this is an awful hack
      # @return [Path] pdf report file
      def self.executive_report
        j2r_path = File.join(SMF_SERVEUR, 'Jacinthe', 'Tools', 'Library', 'JacintheReports')
        ruby_file = File.join(j2r_path, 'lib', 'j2r', 'audits', 'tableau_de_bord.rb')
        connect_mode = 'exploitation'
        require_relative(ruby_file)
        dir = File.join(DATADIR, 'Archives')
        JacintheReports.executive_report_file(connect_mode, dir)
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
