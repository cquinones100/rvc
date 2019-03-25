class RequiredLocalNotDefined < StandardError
  def initialize(msg = self.message, base:, undefined_required_locals:)
    @base = base
    @undefined_required_locals = undefined_required_locals

    super(msg)
  end

  def message
    "#{@base} expected #{@undefined_required_locals} to be defined"
  end
end

