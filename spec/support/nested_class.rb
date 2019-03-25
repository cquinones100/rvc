class NestedClass < Rvc::Component
  def render
    html do
      <<~HTML
      <div>I'm Nested</div>
      HTML
    end
  end
end
