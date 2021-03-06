module Rvc
  class JavascriptFunction < String
    attr_reader :block, :arguments, :name

    def initialize(block:, arguments: [], name: nil)
      @name = name
      @block = block
      @arguments = arguments

      self << to_invocation
    end

    def to_s
      self
    end

    def to_script_tag
      <<~JS
        <script id='#{object_id}'>
          (function() {
            var script = document.createElement('script');
            script.innerHTML = "#{to_function.gsub("\n", '')}";
            document.getElementsByTagName('head')[0].appendChild(script);
            document.getElementById('#{object_id}').remove();
          })();
        </script>
      JS
    end

    def to_function_name
      return '' if name.nil?

      name
    end

    def to_invocation
      return '' if name.nil?

      "#{name}(#{arguments.values.join(', ')});"
    end

    def to_function
      <<~JS
        function #{name}(#{@arguments.keys.join(',')}){#{block.call}}
      JS
    end
    
    def to_encapsulated_function
      <<~JS
       (function(#{arguments.keys.join(',')}){#{block.call}})
      JS
    end

    def iifeize
      <<~JS
      (function(#{arguments.keys.join(',')}) {
        #{block.call}
      })(#{arguments.values.join(', ')})
      JS
    end
  end
end

