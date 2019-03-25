require './lib/rvc/component'
require './lib/rvc/required_local_not_defined'
require './spec/support/nested_class'
require './lib/rvc/javascript_function'

RSpec.describe Rvc::Component do
  subject { mock_class.render }

  describe '.render' do
    describe 'rendering' do
      let(:mock_class) do
        class MockClass < Rvc::Component
          def render
            html do
              <<~HTML
              <div>hi</div>
              HTML
            end
          end
        end

        MockClass
      end

      let(:expected_html) { '<div>hi</div>' }

      it { is_expected.to eq expected_html }
    end

    describe 'rendering locals' do
      let(:mock_class) do
        class MockClassWithLocals < Rvc::Component
          locals :name

          def render
            html do
              <<~HTML
              <div>hi #{@name}</div>
              HTML
            end
          end
        end

        MockClassWithLocals
      end

      let(:name) { 'Carlos' }

      let(:expected_html) { "<div>hi #{name}</div>" }

      subject { mock_class.render(name: name) }

      it { is_expected.to eq expected_html }
    end

    describe 'required locals' do
      let(:mock_class) do
        class MockClassWithRequiredLocals < Rvc::Component
          locals name: :required

          def render
            html do
              <<~HTML
              <div>hi #{@name}</div>
              HTML
            end
          end
        end

        MockClassWithRequiredLocals
      end

      let(:name) { 'Carlos' }

      it { expect { subject }.to raise_error RequiredLocalNotDefined }
    end

    describe 'nesting elements' do
      context 'when nested shallowly' do
        let(:mock_class) do
          class MockClassWithNestingElementsShallow < Rvc::Component
            require_components NestedClass: './spec/support/nested_class.rb'

            def render
              NestedClass do; end
            end
          end

          MockClassWithNestingElementsShallow
        end

        let(:expected_html) { "<div>I'm Nested</div>" }

        it { is_expected.to eq expected_html }
      end

      context 'when nested deeply' do
        let(:mock_class) do
          class MockClassWithNestingElementsDeeply < Rvc::Component
            require_components DivLikeClass: './spec/support/div_like_class.rb',
              NestedClass: './spec/support/nested_class.rb'

            def render
              DivLikeClass id: '1' do
                DivLikeClass id: '2' do
                  NestedClass do; end
                end
              end
            end
          end

          MockClassWithNestingElementsDeeply
        end

        let(:expected_html) do
          "<div id='1'><div id='2'><div>I'm Nested</div></div></div>"
        end

        it { is_expected.to eq expected_html }
      end
    end

    describe 'inlining elements' do
      let(:mock_class) do
        class MockClassWithInliningElements < Rvc::Component
          require_components DivLikeClass: './spec/support/div_like_class.rb',
            NestedClass: './spec/support/nested_class.rb'

          def render
            inline do |container|
              container.add { DivLikeClass id: '1' do; end }

              container.add { NestedClass do; end }
            end
          end
        end

        MockClassWithInliningElements
      end

      let(:expected_html) { "<div id='1'></div><div>I'm Nested</div>" }

      it { is_expected.to eq expected_html }
    end

    describe 'conditional rendering' do
      context 'when if else blocks' do
        let(:mock_class) do
          class MockClassWithConditionalRendering < Rvc::Component
            require_components DivLikeClass: './spec/support/div_like_class.rb'

            def render
              DivLikeClass id: '1' do
                if true
                  'truth'
                else
                  'false'
                end
              end
            end
          end

          MockClassWithConditionalRendering
        end

        let(:expected_html) { "<div id='1'>truth</div>" }

        it { is_expected.to eq expected_html }
      end

      context 'when inlining' do
        let(:mock_class) do
          class MockClassInliningWithConditionalRendering < Rvc::Component
            require_components DivLikeClass: './spec/support/div_like_class.rb'

            def render
              DivLikeClass id: '1' do
                inline do |container|
                  if true
                    container.add { 'truth' }
                  else
                    container.add { 'false' }
                  end
                end
              end
            end
          end

          MockClassInliningWithConditionalRendering
        end

        let(:expected_html) { "<div id='1'>truth</div>" }

        it { is_expected.to eq expected_html }
      end
    end
  end

  describe 'handling javascript' do
    let(:mock_class) do
      class MockClassWithJavascript < Rvc::Component
        require_components DivLikeClass: './spec/support/div_like_class.rb'

        def render
          DivLikeClass id: '1', onclick: js_onclick do
            'hi'
          end
        end

        private

        def js_onclick
          JavascriptFunction name: 'divLikeClassOnClick' do
            <<~JS
              console.log('hi');
            JS
          end
        end
      end

      MockClassWithJavascript
    end

    describe '.render' do
      let(:expected_html) do
        <<~HTML
          <script>
            (function() {
              var script = document.createElement('script');
              script.innerHTML = "function divLikeClassOnClick(){console.log('hi');}";
              document.getElementsByTagName('head')[0].appendChild(script);
            })();
          </script>
          <div id='1' onclick='divLikeClassOnClick();'>hi</div>
        HTML
      end

      subject { mock_class.render.gsub("\n", '') }

      it { is_expected.to eq expected_html.gsub("\n", '') }
    end
  end
end
