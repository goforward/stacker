require 'memoist'
require 'stacker/differ'
require 'stacker/stack/component'
require 'stacker/stack/parameter'

module Stacker
  class Stack
    class Parameters < Component

      extend Memoist

      # everything required by the template
      def template_definitions
        stack.template.local.fetch 'Parameters', {}
      end

      def region_defaults
        stack.region.defaults.fetch 'parameters', {}
      end

      def global_defaults
        stack.region.defaults.fetch 'globalParameterFile', {}
      end

      # template defaults merged with region and stack-specific overrides
      def local
        region_defaults = stack.region.defaults.fetch 'parameters', {}
        global_defaults = stack.region.defaults.fetch 'globalParameterFile', {}
        global_vars = YAML.load_file(global_defaults)

        template_defaults = Hash[
          template_definitions.select { |_, opts|
            opts.key?('Default')
          }.map { |name, opts|
            [name, opts['Default']]
          }
        ]

        available = template_defaults.merge(
          global_vars
        ).merge(
          region_defaults
        ).merge(
          stack.options.fetch 'parameters', {}
        )

        available.slice(*template_definitions.keys)
      end

      def missing
        template_definitions.keys - local.keys
      end

      def remote
        Hash[client.parameters.map do |p|
               [p.parameter_key, p.parameter_value]
             end]
      end
      memoize :remote

      def resolved
        Hash[parameters.map { |k, v| [ k, v.resolved ] }]
      end
      memoize :resolved

      def dependencies
        parameters.map(&:last).map(&:dependencies).flatten
      end
      memoize :dependencies

      def diff *args
        Differ.yaml_diff Hash[resolved.sort], Hash[remote.sort], *args
      end
      memoize :diff

      private

      def parameters
        local.map { |k, v| [k, Parameter.new(v, stack.region)] }
      end

    end
  end
end
