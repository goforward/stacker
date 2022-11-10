require 'stacker/resolvers/resolver'
require 'stacker/stack/parameter'

module Stacker
  module Resolvers

    class GlobalVarResolver < Resolver

      def resolve
        global_defaults = region.defaults.fetch 'globalParameterFile', {}
        global_vars = YAML.load_file(global_defaults)
        global_vars[ref]
      end

    end

  end
end
