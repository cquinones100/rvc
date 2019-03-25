require './lib/rvc/base'

module Rvc
  class Component
    class << self
      def render(base: nil, **args, &block)
        component = new(base: base, block: block, **args)

        component.base.render inline: component.render
      end

      def locals(*args, **required_args)
        define_method(:registered_locals) { args + required_args.keys }

        define_method(:required_locals) do
          required_args.each_with_object([]) do |(arg, value), acc|
            acc << arg if value == :required
          end
        end
      end

      def require_components(**components)
        components.each do |component, path|
          require path

          define_method(component) do |base: nil, **args, &block|
            Kernel.const_get(component)
              .render(base: base, block: block, **args)
          end
        end
      end
    end

    attr_reader :base

    def initialize(base: nil, block:, **args)
      @base = base || Base.new(base: self)
      @block = block

      if respond_to? :registered_locals 
        registered_locals.each do |local|
          instance_variable_set("@#{local}", args[local])
        end
      end

      unless undefined_required_locals.empty?
        raise RequiredLocalNotDefined.new(
          base: self,
          undefined_required_locals: undefined_required_locals
        )
      end
    end

    def html
      base.render inline: yield
    end

    private

    def undefined_required_locals
      return [] unless respond_to? :required_locals

      required_locals.find_all do |local|
        instance_variable_get("@#{local}").nil?
      end
    end

    private

    attr_reader :block
  end
end
