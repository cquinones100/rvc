require './lib/rvc/component'

class Index < Rvc::Component
  require_components Div: './spec/support/div',
    TextInput: './spec/support/text_input',
    FeatureDemo: './spec/support/demo/feature_demo',
    JavascriptDemo: './spec/support/demo/javascript_demo',
    HtmlDemo: './spec/support/demo/html_demo',
    TestingDemo: './spec/support/demo/testing_demo'

  def render
    <<~HTML
      <html>
        <head>
          <title>RVC</title>
          <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        </head>
        #{body}
      </html>
    HTML
  end

  def body
    Div id: 'container', class: 'container' do
      inline do |container|
        container.add do
          Div class: 'row' do
            inline do |title_row_container|
              title_row_container.add do
                Div class: 'col-md-8 pull-right' do
                  <<~HTML
                  <h1>RVC (Ruby View Components)</h1>
                  HTML
                end
              end

              title_row_container.add do
                Div class: 'col-md-4' do
                  <<~HTML
                  <a href='https://github.com/cquinones100/rvc_compiler'>
                    View on Github
                  </a>
                  HTML
                end
              end
            end
          end
        end

        container.add do
          Div id: 'first-row', class: 'row' do
            Div id: 'html-demo-column', class: 'col-md-12' do
              HtmlDemo do; end
            end
          end
        end

        container.add do
          Div id: 'second-row', class: 'row' do
            Div id: 'javascript-demo-column', class: 'col-md-12' do
              JavascriptDemo do; end
            end
          end
        end

        container.add do
          Div id: 'third-row', class: 'row' do
            Div id: 'testing-demo-column', class: 'col-md-12' do
              TestingDemo do; end
            end
          end
        end
      end
    end
  end

  def js_handle_on_change
    JavascriptFunction name: 'handleTextFieldOnChange',
      event: 'event' do
      <<~JS
        var value = event.target.value;

        document.getElementById('hello').innerHTML = 'Hello ' + value + '!';
      JS
    end
  end
end
