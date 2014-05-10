#!/usr/bin/env ruby
# encoding: utf-8

# File: core.rb
# Created: 30/07/13
#
# (c) Michel Demazure & Kenji Lefevre

# stdlib dependencies
require 'fileutils'
require 'set'
require 'yaml'
require 'logger'
require 'tempfile'

# external dependencies
require 'net/ssh'
require 'net/scp'
require 'net/sftp'
require 'net/smtp'

# local config
require_relative '../my_config.rb'

# script methods for Jacinthe Management
module JacintheManagement
  COPYRIGHT = "\u00A9 Michel Demazure & Kenji Lefevre"
  TAB = "\t"

  # connection modes
  JACINTHE_MODE = ADMIN_MODE.merge(database: JACINTHE_DATABASE)
  JACINTHE_ROOT_MODE = ROOT_MODE.merge(database: JACINTHE_DATABASE)
  CATALOG_MODE = ADMIN_MODE.merge(database: CATALOG_DATABASE)

  # second level paths
  TRANSFERT_DIR = File.join(SMF_SERVEUR, 'Transfert')
  DATADIR = File.join(SMF_SERVEUR, 'Data')

  # model mail files
  MODEL_DIR = File.join(SMF_SERVEUR, 'Jacinthe', 'Tools', 'Templates', 'Mail')
end

require_relative('core/utils/file_utilities.rb')
require_relative('core/utils/sql.rb')
require_relative('core/utils/sql_script_file.rb')
require_relative('core/utils/sylk2csv.rb')
require_relative('core/utils/win_file.rb')

require_relative('core/aspaway_importer.rb')
require_relative('core/catalog.rb')
require_relative('core/cli.rb')
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
require_relative('core/commands/command_watcher.rb')
require_relative('core/commands/commands_catalog.rb')
require_relative('core/commands/commands_data.rb')
require_relative('core/commands/commands_drupal.rb')
require_relative('core/commands/commands_electronic.rb')
require_relative('core/commands/commands_extra.rb')
require_relative('core/commands/commands_reset_db.rb')
require_relative('core/commands/commands_sage.rb')
