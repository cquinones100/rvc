require './lib/rvc/component'

class Index < Rvc::Component
  require_components Div: './spec/support/div',
    TextInput: './spec/support/text_input',
    FeatureDemo: './spec/support/demo/feature_demo',
    JavascriptDemo: './spec/support/demo/javascript_demo',
    HtmlDemo: './spec/support/demo/html_demo'

  def render
    <<~HTML
      <html>
        <head>
          <title>RVC</title>
          <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
          <script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>
          <style>
            /* Pretty printing styles. Used with prettify.js. */
            /* Vim sunburst theme by David Leibovic */
            
            pre .str, code .str { color: #65B042; } /* string  - green */
            pre .kwd, code .kwd { color: #E28964; } /* keyword - dark pink */
            pre .com, code .com { color: #AEAEAE; font-style: italic; } /* comment - gray */
            pre .typ, code .typ { color: #89bdff; } /* type - light blue */
            pre .lit, code .lit { color: #3387CC; } /* literal - blue */
            pre .pun, code .pun { color: #fff; } /* punctuation - white */
            pre .pln, code .pln { color: #fff; } /* plaintext - white */
            pre .tag, code .tag { color: #89bdff; } /* html/xml tag    - light blue */
            pre .atn, code .atn { color: #bdb76b; } /* html/xml attribute name  - khaki */
            pre .atv, code .atv { color: #65B042; } /* html/xml attribute value - green */
            pre .dec, code .dec { color: #3387CC; } /* decimal - blue */
            
            pre.prettyprint, code.prettyprint {
            	background-color: #000;
            	border-radius: 8px;
            }
            
            pre.prettyprint {
            	width: 100%;
            	margin: 1em auto;
            	padding: 1em;
            	white-space: pre-wrap;
            }
            
            
            /* Specify class=linenums on a pre to get line numbering */
            ol.linenums { margin-top: 0; margin-bottom: 0; color: #AEAEAE; } /* IE indents via margin-left */
            li.L0,li.L1,li.L2,li.L3,li.L5,li.L6,li.L7,li.L8 { list-style-type: none }
            /* Alternate shading for lines */
            li.L1,li.L3,li.L5,li.L7,li.L9 { }
            
            @media print {
              pre .str, code .str { color: #060; }
              pre .kwd, code .kwd { color: #006; font-weight: bold; }
              pre .com, code .com { color: #600; font-style: italic; }
              pre .typ, code .typ { color: #404; font-weight: bold; }
              pre .lit, code .lit { color: #044; }
              pre .pun, code .pun { color: #440; }
              pre .pln, code .pln { color: #000; }
              pre .tag, code .tag { color: #006; font-weight: bold; }
              pre .atn, code .atn { color: #404; }
              pre .atv, code .atv { color: #060; }
            }
          </style>
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
                  <a href='https://github.com/cquinones100/rvc_compiler'>View on Github</a>
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
