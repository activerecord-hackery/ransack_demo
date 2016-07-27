module Ransack
  module Constants
    ASC                 = 'asc'.freeze
    DESC                = 'desc'.freeze
  end

  module Nodes
    class Condition < Node

      def build_attribute(name = nil, ransacker_args = [])
        Attribute.new(@context, name, ransacker_args).tap do |attribute|
          @context.bind(attribute, attribute.name)
          self.attributes << attribute # if attribute.valid?
          if predicate && !negative?
            @context.lock_association(attribute.parent)
          end
        end
      end
    end
  end
end