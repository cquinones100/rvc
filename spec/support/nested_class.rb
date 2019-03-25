class NestedClass < Rvc::Component
  require_components Div: './spec/support/div.rb'

  def render
    Div { "I'm Nested" }
  end
end
