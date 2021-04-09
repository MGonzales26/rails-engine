class ErrorSerializer
  attr_reader :error
  
  def initialize(error)
    @error = error
  end

  def serialize
    { message: 'bad request',
      error: @errors }
  end
end