require './lib/rvc/component'

class Div < Rvc::Component
  locals :id, :onclick, :class, :style

  def render
    <<~HTML
      <div#{attributes}>#{block.call}</div>
    HTML
  end

  def attributes
    locals.each_with_object('') do |local, acc|
      local_value = instance_variable_get("@#{local}")
      next if local_value.nil?

      acc << " #{local}='#{local_value}'"
    end
  end
end
