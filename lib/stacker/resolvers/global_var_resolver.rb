require 'stacker/resolvers/resolver'

module Stacker
  module Resolvers

    class StackOutputResolver < Resolver

      def resolve
        global_defaults = stack.region.defaults.fetch 'globalParameterFile', {}
        global_vars = YAML.load_file(global_defaults)
        global_vars.fetch ref.fetch('GlobalVar')
      end

    end

  end
end
