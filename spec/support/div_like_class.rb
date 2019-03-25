class DivLikeClass < Rvc::Component
  locals :id, :onclick

  def render
    <<~HTML
      <div id='#{@id}'#{render_onclick}>#{block.call}</div>
    HTML
  end

  def render_onclick
    @onclick ? " onclick='#{@onclick}'" : ''
  end
end
