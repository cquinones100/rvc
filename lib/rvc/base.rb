module Rvc
  class Base
    attr_reader :base

    def initialize(base:) 
      @base = base
    end

    def render(inline:)
      inline.strip
    end
  end
end
