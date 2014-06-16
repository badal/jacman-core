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
require_relative 'config.rb'

require_relative('core/utils/file_utilities.rb')

# script methods for Jacinthe Management
module JacintheManagement
  # path of configuration yaml file
  CONFIG_FILE = ENV['JACMAN_CONFIG']
  fail "Le fichier de configuration n'existe pas" unless CONFIG_FILE

  # core methods for Jacinthe manager
  module Core
    # tab character for csv files
    TAB = "\t"

    # are we on real server ?
    REAL = Conf.config['real']
    # to be used for aspaway_importer when REAL is false
    SMF2_PASSWORD = Conf.config['smf2_password']

    # MySql command
    MYSQL = "#{Conf.mysql['command']} --host #{Conf.mysql['host']}"
    # MySQL dump command
    MYSQLDUMP = "#{Conf.mysql['dump_command']} --host #{Conf.mysql['host']}"

    # databases
    JACINTHE_DATABASE = Conf.config['databases']['jacinthe']
    CATALOG_DATABASE = Conf.config['databases']['catalog']

    # connection modes
    JACINTHE_MODE = Conf.admin_mode.merge(database: JACINTHE_DATABASE)
    JACINTHE_ROOT_MODE = Conf.root_mode.merge(database: JACINTHE_DATABASE)
    CATALOG_MODE = Conf.admin_mode.merge(database: CATALOG_DATABASE)

    # paths
    # # free access directory
    SQL_DUMP_DIR = Conf.config['paths']['dump']
    Utils.make_dir_if_necessary(SQL_DUMP_DIR)
    # top path
    SMF_SERVEUR = Conf.config['paths']['server']
    # second level paths
    TRANSFERT_DIR = File.join(SMF_SERVEUR, 'Transfert')
    DATADIR = File.join(SMF_SERVEUR, 'Data')

    # model mail files
    MODEL_DIR = File.join(SMF_SERVEUR, 'Jacinthe', 'Tools', 'Templates', 'Mail')
    # mail smtp server
    MAIL_MODE = Conf.mail_mode
  end
end

require_relative('core/utils/sql.rb')
require_relative('core/utils/sql_script_file.rb')
require_relative('core/utils/sylk2csv.rb')
require_relative('core/utils/win_file.rb')

require_relative('core/components/aspaway_importer.rb')
require_relative('core/components/catalog.rb')
require_relative('core/components/cli.rb')
require_relative('core/components/clients.rb')
require_relative('core/components/data.rb')
require_relative('core/components/defaults.rb')
require_relative('core/components/drupal.rb')
require_relative('core/components/electronic.rb')
require_relative('core/components/mail.rb')
require_relative('core/components/notification.rb')
require_relative('core/components/notify.rb')
require_relative('core/components/report.rb')
require_relative('core/components/reset_db.rb')
require_relative('core/components/sales.rb')
require_relative('core/components/transmission.rb')

require_relative('core/components/info.rb')

require_relative('core/commands/command.rb')
require_relative('core/commands/command_watcher.rb')
require_relative('core/commands/commands_catalog.rb')
require_relative('core/commands/commands_data.rb')
require_relative('core/commands/commands_drupal.rb')
require_relative('core/commands/commands_electronic.rb')
require_relative('core/commands/commands_extra.rb')
require_relative('core/commands/commands_reset_db.rb')
require_relative('core/commands/commands_sage.rb')
