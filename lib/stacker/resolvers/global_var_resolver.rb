require 'stacker/resolvers/resolver'
require 'stacker/stack/parameter'

module Stacker
  module Resolvers

    class GlobalVarResolver < Resolver

      def resolve
        global_defaults = region.defaults.fetch 'globalParameterFile', {}
        global_vars = YAML.load_file(global_defaults)
        Parameter.new(global_vars[ref], region).resolved
      end

    end

  end
end
