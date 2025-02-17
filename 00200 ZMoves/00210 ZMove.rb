module Battle
  class Move
    # Class managing type-specific Z-Moves
    class ZMove < Basic
      # Original move linked to this Z-Move
      # @return [Integer]
      attr_reader :original_move

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      # @param original_move [Battle::Move] original move linked to this Z-Move
      def initialize(db_symbol, scene, original_move)
        @original_move = original_move
        original_move.real_base_power
        super(db_symbol, 1, 1, scene)
      end

      # List of exceptions for the power calculation
      Z_MOVES_POWER_EXCEPTIONS = {
        struggle: 1,
        mega_drain: 120,
        weather_ball: 160,
        hex: 160,
        v_create: 220,
        flying_press: 170,
        core_enforcer: 140,
        fissure: 180,
        guillotine: 180,
        horn_drill: 180,
        sheer_cold: 180,
      }

      # Get the real base power of the move (taking in account all parameter)
      # @see https://bulbapedia.bulbagarden.net/wiki/Z-Move#Power
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def real_base_power(user, target)
        original_power = @original_move.real_base_power(user, target)

        # @original_move_power < 60
        power = 100

        if Z_MOVES_POWER_EXCEPTIONS.key?(@original_move.db_symbol)
          power = Z_MOVES_POWER_EXCEPTIONS[@original_move.db_symbol]
        else
          power = 120 if original_power >= 60  && original_power <= 69
          power = 140 if original_power >= 70  && original_power <= 79
          power = 160 if original_power >= 80  && original_power <= 89
          power = 175 if original_power >= 90  && original_power <= 99
          power = 180 if original_power >= 100 && original_power <= 109
          power = 185 if original_power >= 110 && original_power <= 119
          power = 190 if original_power >= 120 && original_power <= 129
          power = 195 if original_power >= 130 && original_power <= 139
          power = 200 if original_power >= 140
        end
        log_data("power = #{power} # after #{self.class} real_base_power")

        return power
      end
    end

    Move.register(:s_z_move, ZMove)
  end
end
