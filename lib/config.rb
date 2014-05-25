#!/usr/bin/env ruby
# encoding: utf-8

# File: config.rb
# Created: 11/05/2014
#
# (c) Michel Demazure <michel@demazure.com>

require 'yaml'

class ::Hash
  def symbolize
    {}.tap do |hsh|
      each_pair do |key, value|
        hsh[key.to_sym] = value
      end
    end
  end
end

module JacintheManagement
  module Conf
    CONFIG_FILE = File.join(File.dirname(__FILE__), 'config.ini')

    def self.config
      @config ||= fetch_config
    end

    def self.fetch_config
      Psych.load_file(CONFIG_FILE)
    end

    def self.mysql
      @mysql = config['mysql']
    end

    def self.admin_mode
      @admin_mode ||= mysql['admin'].symbolize
      end

    def self.root_mode
      @root_mode ||= mysql['admin'].symbolize
    end

    def self.mail_mode
      @mail_mode ||= config['mail'].symbolize
    end
  end
end

