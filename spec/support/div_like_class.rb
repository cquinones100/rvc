require './lib/rvc/component'

class DivLikeClass < Rvc::Component
  locals :id, :onclick, :class, :style

  def render
    <<~HTML
      <div id='#{@id}'#{render_onclick}#{render_class}#{render_style}>#{block.call}</div>
    HTML
  end

  def render_onclick
    @onclick ? " onclick='#{@onclick}'" : ''
  end

  def render_class
    @class ? " class='#{@class}'" : ''
  end

  def render_style
    @style ? " style='#{@style}'" : ''
  end
end
