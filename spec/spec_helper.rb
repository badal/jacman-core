#!/usr/bin/env ruby
# encoding: utf-8
#
# File: spec_helper.rb
# Created: 28 June 2013
#
# (c) Michel Demazure <michel@demazure.com>

require 'minitest'
require 'minitest/autorun'

require 'jacman/utils'

require_relative '../lib/jacman/core.rb'

include JacintheManagement

Dir.glob('*_spec.rb') { |f| require_relative f } if __FILE__ == $PROGRAM_NAME
