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
            .to render_html_element(:div)
            .with_attribute(:id, id)
        end
      end

      describe ':onclick' do
        let(:onclick) { 'click(this);' }
        let(:locals) { { onclick: onclick } }

        it do
          is_expected
            .to render_html_element(:div)
            .with_attribute(:onclick, onclick)
        end
      end
    end
  end
end
