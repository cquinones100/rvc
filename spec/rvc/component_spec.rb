require './lib/rvc/component.rb'
require './lib/rvc/required_local_not_defined.rb'
require './spec/support/nested_class.rb'

RSpec.describe Rvc::Component do
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

    subject { mock_class.render }

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

    subject { mock_class.render }

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

      subject { mock_class.render }

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

     subject { mock_class.render }

     fit { is_expected.to eq expected_html }
   end
  end
end
