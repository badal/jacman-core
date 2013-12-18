#!/usr/bin/env ruby
# encoding: utf-8

# File: notification.rb
# Created: 21/08/13
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  # Methods for e-subscriptions notification
  module Notification
    # list to register Tiers with subscriptions but without mail
    @register = [['Id', 'Nom', 'Plages ?'].join(TAB)]

    # Register a line
    # @param [String] line line to be registered
    def self.register(line)
      @register << line
    end

    # tiers for notification
    Tiers = Struct.new(:tiers_id, :name, :ranges, :mails, :drupal)

    # WARNING: Electronic::Subscription and Notification::Subscription are different
    # Electronic subscriptions for notifications
    # noinspection RubyConstantNamingConvention
    Subscription = Struct.new(:id, :revue, :year, :ref, :billing)

    # reopening class
    class Subscription
      # @return [String] report for mail
      def report
        "#{revue} (#{year}) ref:#{ref}"
      end
    end

    # sql to extract tiers
    SQL_TIERS = SqlScriptFile.new('tiers_ip_infos').script

    # sql to count electronic subscriptions to be notified
    SQL_SUBSCRIPTION_NUMBER = SqlScriptFile.new('subscriptions_number_to_notify').script

    # sql to extract electronic subscriptions to be notified
    SQL_SUBSCRIPTIONS = SqlScriptFile.new('subscriptions_to_notify').script

    # sql to update base after notification
    SQL_UPDATE = SqlScriptFile.new('update_subscription_notified').script

    # count and return number of notifications to be done
    # @return [Integer] number of notifications to be done
    def self.notifications_number
      Sql.answer_to_query(ADMIN_MODE, SQL_SUBSCRIPTION_NUMBER)[1].to_i
    end

    # build @all_subscription and @tiers_list
    def self.get_subscriptions_and_tiers
      @all_subscriptions = []
      tiers_list = []
      Sql.answer_to_query(ADMIN_MODE, SQL_SUBSCRIPTIONS).drop(1).each do |line|
        items = line.chomp.split(TAB)
        tiers_id = items.pop.to_i
        (@all_subscriptions[tiers_id] ||= []) << Subscription.new(*items)
        tiers_list << tiers_id
      end
      @tiers_list = tiers_list.sort.uniq
    end

    # @param [Integer|#to_i] tiers_id tiers identification
    # @return [Array<Subscription>] all subscriptions for this tiers
    def self.all_subscriptions(tiers_id)
      get_subscriptions_and_tiers unless @all_subscriptions
      @all_subscriptions[tiers_id.to_i]
    end

    # @return [Array<Integer>] list of tiers_id appearing in subscriptions
    def self.tiers_list
      get_subscriptions_and_tiers unless @tiers_list
      @tiers_list
    end

    # @return [Array<Tiers>] list of all Jacinthe Tiers
    def self.get_all_tiers
      @tiers = []
      Sql.answer_to_query(ADMIN_MODE, SQL_TIERS).drop(1).each do |line|
        items = line.split(TAB)
        parameters = format_items(items)
        @tiers[parameters[0]] = Tiers.new(*parameters)
      end
    end

    # @param [Array<String>] items split line form sql answer
    # @return [Array] parameters for Tiers struct
    def self.format_items(items)
      number = items[0].to_i
      name = items[2] == 'NULL' ? items[1] : items[2] + ' ' + items[1]
      ranges = clean_split('\\n', items[3])
      mails = clean_split(',', items[4].chomp)
      [number, name, ranges, mails]
    end

    # @param [String] sep separator
    # @param [String] string string to be split
    # @return [Array<String|nil>] formatted splitting of string
    def self.clean_split(sep, string)
      string.split(sep).delete_if { |item| item == 'NULL' }
    end

    # @param [Integer|#to_i] tiers_id tiers identification
    # @return [Tiers] this Tiers
    def self.get_tiers(tiers_id)
      get_all_tiers unless @tiers
      @tiers[tiers_id.to_i]
    end

    # @return [String] time stamp for files
    def self.time_stamp
      Time.now.strftime('%Y-%m-%d')
    end

    # tell JacintheD that subscription is notified
    # @param [STRING] subs_id subscription identity
    def self.update(subs_id)
      query = SQL_UPDATE
      .sub(/::abonnement_id::/, subs_id)
      .sub(/::time_stamp::/, time_stamp)
      if REAL
        Sql.query(ADMIN_MODE, query) # this is real mode
      else
        puts "SQL : #{query}" # this is  demo mode
      end
    end

    # command to notify all subscriptions
    def self.notify_all
      number = notifications_number
      if number > 0
        puts "#{number} notifications à faire"
        do_notify_all
      else
        puts 'Pas de notification à faire'
      end
    end

    # Notify all subscriptions
    def self.do_notify_all
      tiers_list.each { |tiers_id| Notify.new(tiers_id).notify }
      puts "#{tiers_list.size} mails(s) de notification envoyé(s)"
      size = @register.size
      save_register
      puts "<b>#{size - 1} abonné(s) dépourvu(s) d'adresse mail</b>" if size > 1
    end

    NO_MAIL_FILE = File.join(DATADIR, 'tiers_sans_mail.txt')

    # save the list of registered Tiers in a csv file
    def self.save_register
      File.open(NO_MAIL_FILE, 'w:utf-8') do |file|
        @register.each { |line| file.puts(line) }
      end
      puts "File #{NO_MAIL_FILE} saved"
    end

    # open in editor tiers without mail file
    def self.show_tiers_without_mail
      Utils.open_in_editor(NO_MAIL_FILE)
    end

    # @return [Integer] number of tiers without mail
    def self.tiers_without_mail
      File.foreach(NO_MAIL_FILE).count - 1
    end
  end
end

if __FILE__ == $PROGRAM_NAME

  include JacintheManagement
  puts Notification.notifications_number

end
