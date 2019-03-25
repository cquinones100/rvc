require './lib/rvc/component'

class FeatureDemo < Rvc::Component
  require_components Div: './spec/support/div'

  locals title: :required, summary: :required, embed_code: :required

  def render
    Div id: "#{@title}-feature-demo", class: 'card' do
      Div class: 'card-body' do
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
            Div class: 'row' do
              inline do |row_container|
                row_container.add do
                  Div class: 'col-md-4' do
                    block.call
                  end
                end

                row_container.add do
                  Div class: 'col-md-8' do
                    @embed_code
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
