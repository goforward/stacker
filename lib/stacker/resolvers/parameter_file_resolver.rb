require 'stacker/resolvers/resolver'

module Stacker
  module Resolvers

    class ParameterResolver < Resolver

      def resolve
        parameter_file = region.defaults.fetch 'parameterFile', {}
        file_vars = YAML.load_file(parameter_file)
        file_vars[ref]
      end

    end

  end
end
