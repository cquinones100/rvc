require './lib/rvc/component'

class FeatureDemo < Rvc::Component
  require_components DivLikeClass: './spec/support/div_like_class'

  locals title: :required, summary: :required, code: :required

  def render
    DivLikeClass id: "#{@title}-feature-demo", class: 'card' do
      DivLikeClass class: 'card-body' do
        inline do |container|
          container.add do
            <<~HTML
              <h3>#{@title}</h3>
            HTML
          end

          container.add do
            <<~HTML
              <hr>
            HTML
          end

          container.add do
            <<~HTML
              <p class='card-text' display: 'block'>#{@summary}</p>
            HTML
          end

          container.add do
            DivLikeClass class: 'row' do
              inline do |row_container|
                row_container.add do
                  DivLikeClass class: 'col-md-4' do
                    block.call
                  end
                end

                row_container.add do
                  DivLikeClass class: 'col-md-8' do
                    <<~HTML
                      <pre class='prettyprint' style: 'border:none;'>
                        <code>
                     #{sanitized_code('', @code).strip}
                        <code>
                      </pre>
                    HTML
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def format_html(code)
    code.gsub('<', '&lt;').gsub('>', '&gt;')
  end

  def sanitized_code(string = '', code)
    index = heredoc_index(code)

    unless index
      string += code

      return string
    end

    string += code[0...index + 7]

    code = code[index + 7..-1]

    end_index = end_heredoc_index(code)

    html_code = code[0...end_index]

    string += format_html(html_code)

    code = code[end_index..-1]

    sanitized_code(string, code)
  end

  def heredoc_index(code)
    code.index("<<~HTML")
  end

  def end_heredoc_index(code)
    code.index("HTML")
  end
end
