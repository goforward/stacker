require 'stacker/resolvers/resolver'

module Stacker
  module Resolvers

    class GlobalVarResolver < Resolver

      def resolve
        global_defaults = region.defaults.fetch 'globalParameterFile', {}
        global_vars = YAML.load_file(global_defaults)
        global_vars[ref].resolved
      end

    end

  end
end
