module Battle
  class Move
    # Class managing type-specific Z-Moves
    class ZMove < Basic
      # Power of the original move linked to this Z-Move
      # @return [Integer]
      attr_reader :original_move_power

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      # @param original_move [Battle::Move] original move linked to this Z-Move
      def initialize(db_symbol, scene, original_move)
        @original_move_power = data_move(original_move.db_symbol).power
        super(db_symbol, 1, 1, scene)
      end

      # Get the real base power of the move (taking in account all parameter)
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def real_base_power(user, target)
        power = 200
        case 
        when @original_move_power <= 55
          power = 100
        when @original_move_power <= 95
          power = (@original_move_power / 10) * 20
        when @original_move_power <= 135
          power = (@original_move_power / 10) * 5 + 130
        else
          power = 200
        end
        log_data("power = #{power} # after #{self.class} real_base_power")

        return power
      end
    end

    Move.register(:s_z_move, ZMove)
  end
end
