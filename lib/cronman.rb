#!/usr/bin/env ruby
# encoding: utf-8

# File: cronman.rb
# Created: 14/09/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'jacman/core.rb'

call_name = ARGV.first
JacintheManagement::Core::Command.cron_run(call_name)
