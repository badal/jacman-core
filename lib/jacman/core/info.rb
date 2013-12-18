#!/usr/bin/env ruby
# encoding: utf-8/

# File: info
# Created: 9/12/2013
#
# (c) Michel Demazure

module JacintheManagement
  # Information on pending actions
  module Info
    class << self
      attr_reader :client_files_number,
                  :clients_to_export_number,
                  :remaining_sales_number,
                  :notifications_number,
                  :invalid_ranges_number,
                  :tiers_without_mail

      # fetch values and refresh the variables
      def refresh
        @client_files_number = Clients.pending_client_files_number
        @clients_to_export_number = Clients.clients_to_export_number
        @remaining_sales_number = Sales.remaining_sales.size
        @notifications_number = Notification.notifications_number
        @invalid_ranges_number = Electronic.invalid_ranges.size
        @tiers_without_mail = Notification.tiers_without_mail
      end

      # @return [Array<String>] lines reporting state of things
      def report
        refresh
        [
            "#{@client_files_number} fichiers clients en cours",
            "#{@clients_to_export_number} clients à exporter",
            "#{@remaining_sales_number} ventes non importées",
            "#{@notifications_number} notifications à faire",
            "#{@invalid_ranges_number} plages ip invalides",
            "#{@tiers_without_mail} abonnés électroniques sans mail"
        ]
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__

  include JacintheManagement
  require_relative '../core.rb'
  puts Info.report

end
