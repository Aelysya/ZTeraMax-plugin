module Battle
  class Move
    class MaxMove < Basic
      # Original move linked to this Max Move
      # @return [Battle::Move]
      attr_reader :original_move

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      # @param original_move [Battle::Move] original move linked to this Z-Move
      def initialize(db_symbol, scene, original_move)
        @original_move = original_move
        @is_max = true
        super(db_symbol, original_move.pp, original_move.ppmax, scene)
      end

      # Is the skill physical ?
      # @return [Boolean]
      def physical?
        return original_move.physical?
      end

      # Is the skill special ?
      # @return [Boolean]
      def special?
        return original_move.special?
      end
    end
    Move.register(:s_max_move, MaxMove)
  end
end
