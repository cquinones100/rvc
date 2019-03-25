class DivLikeClass < Rvc::Component
  locals :id

  def render
    <<~HTML
      <div id='#{@id}'>#{block.call}</div>
    HTML
  end
end
