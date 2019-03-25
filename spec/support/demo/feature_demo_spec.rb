require './spec/support/demo/feature_demo'

RSpec.describe FeatureDemo do
    let(:code) do
      "inline do |demo_container|\n  demo_container.add do\n    <<~HTML\n      <h1 id='hello'>Hello!</h1>\n    HTML\n  end\n\n  demo_container.add do\n    DivLikeClass id: 'enter-your-name' do\n      'Enter your name'\n    end\n  end\n\n  demo_container.add { TextInput onchange: js_handle_on_change }\nend\n"
    end
  describe '#sanitized_code' do
    let(:expected_code) do
    "inline do |demo_container|\n  demo_container.add do\n    <<~HTML\n      &lt;h1 id='hello'&gt;Hello!&lt;/h1&gt;\n    HTML\n  end\n\n  demo_container.add do\n    DivLikeClass id: 'enter-your-name' do\n      'Enter your name'\n    end\n  end\n\n  demo_container.add { TextInput onchange: js_handle_on_change }\nend\n"
    end

    subject do
      described_class.new(
        title: 'test',
        summary: 'test',
        code: code,
        block: ->{ nil }
      ).sanitized_code(code)
    end

    it { is_expected.to eq expected_code }
  end

  describe '#formatted' do
    let(:code) do
      <<~HTML
        <h1>hi</h1>
      HTML
    end

    let(:expected_html) do
      <<~HTML
        &lt;h1&gt;hi&lt;/h1&gt;
      HTML
    end

    subject do
      described_class.new(
        title: 'test',
        summary: 'test',
        code: code,
        block: ->{ nil }
      ).format_html(code)
    end

    it { is_expected.to eq expected_html }
  end
end
