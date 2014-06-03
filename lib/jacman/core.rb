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
require_relative '../config.rb'

# script methods for Jacinthe Management
module JacintheManagement
  # path of configuration yaml file
  CONFIG_FILE = ENV['JACMAN_CONFIG']

  # core methods for Jacinthe manager
  module Core
    # tab character for csv files
    TAB = "\t"

    # are we on real server ?
    REAL = Conf.config['real']
    # to be used for aspaway_importer when REAL is false
    SMF2_PASSWORD = Conf.config['smf2_password']

    # MySql command
    MYSQL = Conf.mysql['command']
    # MySQL dump system command
    MYSQLDUMP = Conf.mysql['dump_command']

    # databases
    JACINTHE_DATABASE = Conf.config['databases']['jacinthe']
    CATALOG_DATABASE = Conf.config['databases']['catalog']

    # connection modes
    JACINTHE_MODE = Conf.admin_mode.merge(database: JACINTHE_DATABASE)
    JACINTHE_ROOT_MODE = Conf.root_mode.merge(database: JACINTHE_DATABASE)
    CATALOG_MODE = Conf.admin_mode.merge(database: CATALOG_DATABASE)

    # paths
    # top path
    SMF_SERVEUR = Conf.config['paths']['server']
    # free access directory
    SQL_DUMP_DIR = Conf.config['paths']['dump']
    # second level paths
    TRANSFERT_DIR = File.join(SMF_SERVEUR, 'Transfert')
    DATADIR = File.join(SMF_SERVEUR, 'Data')

    # model mail files
    MODEL_DIR = File.join(SMF_SERVEUR, 'Jacinthe', 'Tools', 'Templates', 'Mail')
    # mail smtp server
    MAIL_MODE = Conf.mail_mode
  end
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
