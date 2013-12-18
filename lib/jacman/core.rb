#!/usr/bin/env ruby
# encoding: utf-8

# File: core.rb
# Created: 30/07/13
#
# (c) Michel Demazure & Kenji Lefevre

require 'fileutils'
require 'set'
require 'yaml'
require 'logger'
require 'tempfile'
require 'net/ssh'
require 'net/scp'
require 'net/sftp'
require 'net/smtp'

require_relative '../../lib/my_config.rb'

# script methods for Jacinthe Management
module JacintheManagement
  # JacMan directory
  HEAD_DIRECTORY = File.join(File.dirname(__FILE__), '..', '..')

  TAB = "\t"
end

require_relative('core/version.rb')

require_relative('core/utils/file_utilities.rb')
require_relative('core/utils/sql.rb')
require_relative('core/utils/sql_script_file.rb')
require_relative('core/utils/sylk2csv.rb')
require_relative('core/utils/win_file.rb')

require_relative('core/aspaway_importer.rb')
require_relative('core/catalog.rb')
require_relative('core/clients.rb')
require_relative('core/data.rb')
require_relative('core/defaults.rb')
require_relative('core/drupal.rb')
require_relative('core/electronic.rb')
require_relative('core/mail.rb')
require_relative('core/notification.rb')
require_relative('core/notify.rb')
require_relative('core/report.rb')
require_relative('core/reset_db.rb')
require_relative('core/sales.rb')
require_relative('core/transmission.rb')

require_relative('core/info.rb')
require_relative('core/commands/command.rb')

require_relative('core/commands/commands(sage).rb')
require_relative('core/commands/commands(data).rb')
require_relative('core/commands/commands(drupal).rb')
require_relative('core/commands/commands(electronic).rb')
require_relative('core/commands/commands(extra).rb')
require_relative('core/commands/commands(catalog).rb')
