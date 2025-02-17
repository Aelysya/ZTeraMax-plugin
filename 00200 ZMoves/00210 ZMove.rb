module Battle
  class Move
    # Class managing type-specific Z-Moves
    class ZMove < Basic
      # Power of the original move linked to this Z-Move
      # @return [Integer]
      attr_reader :original_move_power
      # db_symbol of the original move linked to this Z-Move
      # @return [Integer]
      attr_reader :original_move_db_symbol

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      # @param original_move [Battle::Move] original move linked to this Z-Move
      def initialize(db_symbol, scene, original_move)
        @original_move_power = data_move(original_move.db_symbol).power
        @original_move_db_symbol = original_move.db_symbol
        super(db_symbol, 1, 1, scene)
      end

      # List of exceptions for the power calculation
      Z_MOVES_POWER_EXCEPTIONS = {
        mega_drain: 120,
        weather_ball: 160,
        hex: 160,
        v_create: 220,
        flying_press: 170,
        core_enforcer: 140,
      }

      # Get the real base power of the move (taking in account all parameter)
      # @see https://bulbapedia.bulbagarden.net/wiki/Z-Move#Power
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def real_base_power(user, target)
        # @original_move_power <= 55
        power = 100

        if Z_MOVES_POWER_EXCEPTIONS.key?(@original_move_db_symbol)
          power = Z_MOVES_POWER_EXCEPTIONS[@original_move_db_symbol]
        else
          power = 120 if @original_move_power == 60  || @original_move_power == 65
          power = 140 if @original_move_power == 70  || @original_move_power == 75
          power = 160 if @original_move_power == 80  || @original_move_power == 85
          power = 175 if @original_move_power == 90  || @original_move_power == 95
          power = 180 if @original_move_power == 100 || @original_move_power == 105
          power = 185 if @original_move_power == 110 || @original_move_power == 115
          power = 190 if @original_move_power == 120 || @original_move_power == 125
          power = 195 if @original_move_power == 130 || @original_move_power == 135
          power = 200 if @original_move_power >= 140
        end
        log_data("power = #{power} # after #{self.class} real_base_power")

        return power
      end
    end

    Move.register(:s_z_move, ZMove)
  end
end
