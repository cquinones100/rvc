module Rvc
  module Testing
    module Matchers
      RSpec::Matchers.define :render_html_element do |element|
        class RenderHtmlElementHelper
          attr_writer :subject, :attribute, :value
         
          def initialize(element:)
            @element = element
            @errors = []
          end

          def valid?
            perform_validations

            errors.empty?
          end

          def error_messages
            errors.join("\n")
          end

          private

          def perform_validations
            validate_element unless validate_attribute?
            validate_attribute if validate_attribute?
          end

          def validate_attribute
            position = subject =~ /<div(\s|\w|\W)*#{attribute_to_string}(\s|\w|W)*>/

            errors << 'Attribute not found' if position.nil?
          end

          def validate_attribute?
            !attribute.nil? && !value.nil?
          end

          def attribute_to_string
            escape_regex("#{attribute}='#{value}'")
          end

          def escape_regex(code)
            code.gsub(/[\(\)]/, '(' => '\(', ')' => '\)')
          end

          attr_reader :element, :subject, :attribute, :value, :errors
        end

        helper = RenderHtmlElementHelper.new(element: element)

        match do
          helper.subject = subject

          helper.valid?
        end

        chain :with_attribute do |attribute, value|
          helper.attribute = attribute
          helper.value = value
        end

        failure_message do
          helper.error_messages
        end
      end
    end
  end
end
