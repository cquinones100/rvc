class JavascriptDemo < Rvc::Component
  require_components FeatureDemo: './spec/support/demo/feature_demo',
    DivLikeClass: './spec/support/div_like_class',
    TextInput: './spec/support/text_input'

  def render
    FeatureDemo title: 'Javascript',
      summary: 'Write Javascript directly in components.',
      embed_code: embed_code do
      eval code
    end
  end

  private

  def embed_code
    <<~HTML
    <script src="https://gist.github.com/cquinones100/f968d73799c9e51ef138683f1138834a.js"></script>
    HTML
  end
  def code
    <<~RUBY
      inline do |demo_container|
        demo_container.add do
          <<~HTML
            <h1 id='hello'>Hello!</h1>
          HTML
        end

        demo_container.add do
          DivLikeClass id: 'enter-your-name' do
            'Enter your name'
          end
        end

        demo_container.add { TextInput onchange: js_handle_on_change }
      end
    RUBY
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
