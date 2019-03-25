module Rvc
  class Inline < Array
    attr_reader :base

    def initialize(base:)
      @base = base
    end

    def add(&block)
      self << block
    end

    def render
      map { |block| block.call }.join
    end
  end
end

