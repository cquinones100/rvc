require './spec/support/div'
require './lib/rvc/testing/matchers'

RSpec.describe Div do
  describe '#render' do
    let(:locals) { {} }

    subject { described_class.render(**locals) }

    describe 'locals' do
      describe ':id' do
        let(:id) { 'div-1' }
        let(:locals) { { id: id } }

        it do
          is_expected
            .to render_html_element(:div).with_attribute(:id, id)
        end
      end

      describe ':onclick' do
        let(:onclick) { 'click(this);' }
        let(:locals) { { onclick: onclick } }

        it do
          is_expected
            .to render_html_element(:div).with_attribute(:onclick, onclick)
        end
      end

      describe ':class' do
        let(:class_name) { 'a-div' }
        let(:locals) { { class: class_name } }

        it do
          is_expected
            .to render_html_element(:div).with_attribute(:class, class_name)
        end
      end

      describe ':style' do
        let(:style) { 'margin:auto;' }
        let(:locals) { { style: style } }

        it do
          is_expected
            .to render_html_element(:div).with_attribute(:style, style)
        end
      end
    end
  end
end
