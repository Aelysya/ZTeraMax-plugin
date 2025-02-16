module Battle
  class Logic
    # Get the ZMove helper
    # @return [ZMove]
    attr_reader :z_move

    alias default_initialize initialize
    # Create a new Logic instance
    # @param scene [Scene] scene that hold the logic object
    def initialize(scene)
      # ZMove helper
      @z_move = ZMoves.new(scene)
      default_initialize(scene)
    end
  end
end
