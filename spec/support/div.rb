require './lib/rvc/component'

class Div < Rvc::Component
  locals :id, :onclick, :class, :style

  def render
    <<~HTML
      <div#{attributes}>#{render_block}</div>
    HTML
  end

  def render_block
    return '' if block.nil?

    block.call
  end

  def attributes
    locals.each_with_object('') do |local, acc|
      local_value = instance_variable_get("@#{local}")
      next if local_value.nil?

      acc << " #{local}='#{local_value}'"
    end
  end
end
