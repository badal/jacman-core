#!/usr/bin/env ruby
# encoding: utf-8

# File: notification.rb
# Created: 21/08/13
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  module Core
    # class to carry all subscriptions to a given tiers
    class Notify
      # file containing the model of notifications in french
      FRENCH_MODEL_FILE = File.join(MODEL_DIR, 'french_model_mail.txt')
      # file containing the model of notifications in english
      ENGLISH_MODEL_FILE = File.join(MODEL_DIR, 'english_model_mail.txt')
      # subject line of french mails
      FRENCH_SUBJECT = 'Notification de vos e-abonnements'
      # subject line of english mails
      ENGLISH_SUBJECT = 'Notification of yours e-subscriptions'

      # @param [Integer|#to_i] tiers_id tiers identification
      def initialize(tiers_id)
        @tiers = Notification.find_tiers(tiers_id)
        @subscriptions = Notification.to_be_notified_for(tiers_id)
      end

      # do notification for this tiers
      # WARNING: first line is HACK for invalid tiers
      def notify
        return false unless @tiers
        destinations = @tiers.mails.group_by { |dest| dest.split('.').last == 'fr' }
        french = destinations[true]
        other = destinations[false]
        notify_french(french) if french
        notify_english(other) if other
        # register if mails is empty ?
        register_tiers unless french || other
        say_notified
        true
      end

      # send notification in french to this address
      # @param [String] dest mail address
      def notify_french(dest)
        mail(dest, FRENCH_SUBJECT, mail_content(FRENCH_MODEL_FILE))
      end

      # send notification in english to this address
      # @param [String] dest mail address
      def notify_english(dest)
        mail(dest, ENGLISH_SUBJECT, mail_content(ENGLISH_MODEL_FILE))
      end

      # update database
      def say_notified
        @subscriptions.each { |sub| Notification.update(sub.id) }
      end

      # @return [Hash] substitutions to be made to model
      def substitutions
        { TIERS_ID: @tiers.tiers_id.to_s, # rubocop:disable SymbolName
          NAME: @tiers.name,
          RANGES: @tiers.ranges.join("\n"),
          REVUES: @subscriptions.map(&:report).join("\n"),
          DRUPAL: @tiers.drupal.to_s }
      end

      # @param [Path] file path to model file
      # @return [String] mail content for this tiers
      def mail_content(file)
        raw = File.read(file, encoding: 'utf-8')
        substitutions.each_pair do |key, value|
          raw.gsub!(key.to_s, value)
        end
        raw
      end

      # Register this Tiers
      def register_tiers
        ranges = @tiers.ranges.empty? ? 'pas de plages' : 'plages'
        Notification.register [@tiers.tiers_id, @tiers.name, ranges].join(TAB)
      end

      # send mail
      # @param [String] dest email address
      # @param [String] subject subject line of header
      # @param [String] content of mail
      def mail(dest, subject, content)
        mail_to_send = Mail.new(dest, subject, content)
        puts REAL ? mail_to_send.send : mail_to_send.demo
      rescue StandardError => err
        puts report_error(err.message, dest)
      end

      # @param [String] message erreur
      # @param [Array<String>] dest adresses de l'envoi
      # @return [Array<String>] report to be printed
      def report_error(message, dest)
        ['<b>Une erreur est survenue lors de l\'envoi au destinataire suivant :</b>',
         "Erreur : #{message}",
         "Tiers : #{@tiers.name}",
         "Id : #{@tiers.tiers_id}",
         "Adresses : #{dest.join(', ')}"]
      end
    end
  end
end
