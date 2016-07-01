# encoding: utf-8

# File: subscription.rb
# Created: 29/02/12 by KL under name e-abo.rb
# Modified: 15/08/13 by MD
#
# (c) Kenji Lefevre & Michel Demazure

module JacintheManagement
  module Core
    module Electronic
      # Subscription class converts a single subscription with multiple ip ranges
      # into an array of formatted lines describing couples (abo, ip range)
      class Subscription
        # @param [String] tiers tiers ID
        # @param [String] year  year 'YYYY'
        # @param [String] revue revue code
        # @param [String] ranges string of ip ranges
        # @param [String] bonus date of end of bonus time 'MM-DD'
        def initialize(tiers, revue, year, ranges, bonus)
          @tiers = tiers
          @revue = revue
          @ranges = ranges.split('\\n').map{ |item| IP::IPRange.new(item)}
          @start = year + '-01-01'
          @end = (year.to_i + 1).to_s + "-#{bonus}"
        end

        # returns valid ranges expressed as an array of string ('\t' separated)
        # @return [Array<String>] items are (abo, ip range, start, end)
        def valid_ranges
          @ranges.select(&:valid?).map do |range|
            [@tiers, @revue, range.min_and_max, @start, @end].flatten.join(TAB)
          end
        end

        # return invalid ranges expressed as an array of strings ('\t' separated)
        # @return [Array<String>] array of (tiers, range) where range is invalid
        def invalid_ranges
          @ranges.reject(&:accepted).map { |range| [@tiers, range.string].flatten.join(TAB) }
        end
      end
    end
  end
end
