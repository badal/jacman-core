#!/usr/bin/env ruby
# encoding: utf-8

# File: batman.rb
# Created: 29/08/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative 'jacman/require_core.rb'

JacintheManagement::Core::Cli.user.run(ARGV)
