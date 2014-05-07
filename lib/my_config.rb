#!/usr/bin/env ruby
# encoding: utf-8

# File: my_config.rb
# Created: 21/07/13
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  # we are not on server
  REAL = false

  ## sql parameters

  # database
  JACINTHE_DATABASE = 'JacintheD'
  ADMIN_MODE = { user: 'root', password: 'admin', database: JACINTHE_DATABASE }
  ROOT_MODE = { user: 'root', password: 'admin' }
  ROOT_MODE_WITH_DB = { user: 'root', password: 'admin', database: JACINTHE_DATABASE }
  CATALOG_MODE = { user: 'root', password: 'admin', database: 'catalogue' }
  MAIL_MODE = { server: 'smtp.sfr.fr', from: 'michel@demazure.com' }

  private_constant :ADMIN_MODE, :ROOT_MODE, :ROOT_MODE_WITH_DB, :CATALOG_MODE, :MAIL_MODE

  # MySQL client system command
  MYSQL = 'mysql --default-character-set=utf8'

  # MySQL dump system command
  MYSQLDUMP = 'mysqldump'

  # Options for mysqldump
  SQL_DUMP_OPTIONS = '--no-create-info --lock-all-tables --skip-comments ' \
      ' --opt --complete-insert --skip-triggers --default-character-set=utf8 '

  # MYSQL = 'echo'

  # GENERAL PATHS SETTING

  # top path
  SMF_SERVEUR = 'C:/Users/Michel/Documents/Share/SMF_SERVEUR'

  # second level paths

  TRANSFERT_DIR = File.join(SMF_SERVEUR, 'Transfert')
  DATADIR = File.join(SMF_SERVEUR, 'Data')
  CRON_DIR = File.join(DATADIR, 'Cron')

  # model mail files
  MODEL_DIR = File.join(SMF_SERVEUR, 'Jacinthe', 'Tools', 'Templates', 'Mail')

  SQL_DUMP_DIR = 'C:/Temp/Dump'

  # J2R path
  J2R_PATH = File.join(SMF_SERVEUR, 'Jacinthe', 'Tools', 'Library', 'J2R')

  TABLEAU_DE_BORD_FILE = File.join(J2R_PATH, 'lib', 'j2r', 'audits', 'tableau_de_bord.rb')
  J2R_CONNECT_MODE = 'exploitation'

  DRUPAL_PASSWORD = 'ho%$iro86'
  SMF2_PASSWORD = 'RIK%serveur'
  ASPAWAY_PASSWORD = 'I3uoyade'

  private_constant :DRUPAL_PASSWORD, :SMF2_PASSWORD, :ASPAWAY_PASSWORD
end
