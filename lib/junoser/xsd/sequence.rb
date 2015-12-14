require 'junoser/xsd/base'
require 'junoser/xsd/choice'
require 'junoser/xsd/element'

module Junoser
  module Xsd
    class Sequence
      include Base

      def config
        @config ||= children.map {|child|
          case child.name
          when 'choice'
            Junoser::Xsd::Choice.new(child, depth: @depth+1)
          when 'element'
            Junoser::Xsd::Element.new(child, depth: @depth+1)
          when 'any'
            'any'
          else
            raise "ERROR: unknown element: #{child.name}"
          end
        }.compact
      end

      def to_s
        case
        when config.empty?
        when has_single_child_of?(Junoser::Xsd::Choice)
          child = config.first
          str = child.config.map(&:to_s).compact.join(",\n")
          format('c(', str, ')') unless str.empty?
        else
          str = config.map {|c| c.is_a?(String) ? format(OFFSET + c) : c.to_s }.compact.join(",\n")
          format('s(', str, ')')
        end
      end
    end
  end
end
