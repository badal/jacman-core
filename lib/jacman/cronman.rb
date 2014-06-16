#!/usr/bin/env ruby
# encoding: utf-8

# File: cronman.rb
# Created: 14/09/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'core.rb'

JacintheManagement::Core::Command.cron_run(ARGV)
