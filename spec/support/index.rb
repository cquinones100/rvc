require './lib/rvc/component'

class Index < Rvc::Component
  require_components DivLikeClass: './spec/support/div_like_class',
    TextInput: './spec/support/text_input'

  def render
    DivLikeClass.render id: 'welcome' do
      inline do |container|
        container.add do
          <<~HTML
            <h1 id='hello'>Hello!</h1>
          HTML
        end

        container.add do
          DivLikeClass id: 'enter-your-name' do
            'Enter your name'
          end
        end

        container.add { TextInput onchange: js_handle_on_change }
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
