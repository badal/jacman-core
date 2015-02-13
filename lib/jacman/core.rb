#!/usr/bin/env ruby
# encoding: utf-8

# File: core.rb
# Created: 30/07/13
#
# (c) Michel Demazure & Kenji Lefevre

# external dependencies
require 'net/ssh'
require 'net/scp'
require 'net/sftp'
require 'net/smtp'
require 'date'

require_relative('core/version.rb')

require_relative('core/components/aspaway_importer.rb')
require_relative('core/components/catalog.rb')
require_relative('core/components/cli.rb')
require_relative('core/components/clients.rb')
require_relative('core/components/data.rb')
require_relative('core/components/defaults.rb')
require_relative('core/components/drupal.rb')
require_relative('core/components/electronic.rb')
require_relative('core/components/report.rb')
require_relative('core/components/reset_db.rb')
require_relative('core/components/build_catalog_db.rb')
require_relative('core/components/sales.rb')
require_relative('core/components/transmission.rb')

require_relative('core/components/infos.rb')

require_relative('core/commands/command.rb')
require_relative('core/commands/command_watcher.rb')
require_relative('core/commands/commands_catalog.rb')
require_relative('core/commands/commands_data.rb')
require_relative('core/commands/commands_drupal.rb')
require_relative('core/commands/commands_electronic.rb')
require_relative('core/commands/commands_extra.rb')
require_relative('core/commands/commands_reset_db.rb')
require_relative('core/commands/commands_sage.rb')
