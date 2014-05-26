#!/usr/bin/env ruby
# encoding: utf-8

# File: config.rb
# Created: 11/05/2014
#
# (c) Michel Demazure <michel@demazure.com>

require 'yaml'

# reopening core class
class Hash
  # symbolize keys
  # @return [Hash] new Hash with symbolized keys
  def symbolize
    {}.tap do |hsh|
      each_pair do |key, value|
        hsh[key.to_sym] = value
      end
    end
  end
end

module JacintheManagement
  # configuration methods
  module Conf
    # path of configuration yaml file
    CONFIG_FILE = File.join(File.dirname(__FILE__), 'config.ini')

    # fetch and cache configuration
    # @return [Hash] configuration hash
    def self.config
      @config ||= fetch_config
    end

    # @return [Hash] configuration hash
    def self.fetch_config
      Psych.load_file(CONFIG_FILE)
    end

    # @return [Hash] mysql part of configuration
    def self.mysql
      @mysql = config['mysql']
    end

    # @return [Hash] admin sql connection mode
    def self.admin_mode
      @admin_mode ||= mysql['admin'].symbolize
    end

    # @return [Hash] root sql connection mode
    def self.root_mode
      @root_mode ||= mysql['admin'].symbolize
    end

    # @return [Hash] mailer configuration
    def self.mail_mode
      @mail_mode ||= config['mail'].symbolize
    end
  end
end
