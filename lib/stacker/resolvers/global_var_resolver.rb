require 'stacker/resolvers/resolver'

module Stacker
  module Resolvers

    class GlobalVarResolver < Resolver

      def resolve
        global_defaults = region.defaults.fetch 'globalParameterFile', {}
        global_vars = YAML.load_file(global_defaults)
        puts(global_vars)
        puts(ref)
        puts(ref.fetch('GlobalVar'))
        global_vars[ref.fetch('GlobalVar')]
      end

    end

  end
end
