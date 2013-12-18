#!/usr/bin/env ruby
# encoding: utf-8
#
# File: version.rb
# Created: 28 June 2013
#
# (c) Michel Demazure

module JacintheManagement
  module Core
    MAJOR = 1
    MINOR = 0
    TINY = 0

    VERSION = [MAJOR, MINOR, TINY].join('.').freeze
  end
end

if __FILE__ == $PROGRAM_NAME

  puts JacintheManagement::Core::VERSION

end
