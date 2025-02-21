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
        pp = original_move.pp == 0 ? 0 : 1
        super(db_symbol, pp, 1, scene)
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
        sheer_cold: 180
      }

      # Calculates the real base power of a move considering Z-Move exceptions and original move power.
      #
      # @param user [PFM::PokemonBattler] The user of the move.
      # @param target [PFM::PokemonBattler] The target of the move.
      # @return [Integer] The calculated base power of the move.
      # @see https://bulbapedia.bulbagarden.net/wiki/Z-Move#Power

      # The method first retrieves the original power of the move. If the move is listed in the
      # Z_MOVES_POWER_EXCEPTIONS hash, it uses the corresponding power value. Otherwise, it determines
      # the power based on the original power range:
      # - 0..59: 100
      # - 60..69: 120
      # - 70..79: 140
      # - 80..89: 160
      # - 90..99: 175
      # - 100..109: 180
      # - 110..119: 185
      # - 120..129: 190
      # - 130..139: 195
      # - 140 and above: 200
      #
      # The calculated power is then logged and returned.
      def real_base_power(user, target)
        original_power = power = @original_move.real_base_power(user, target)

        if Z_MOVES_POWER_EXCEPTIONS.key?(@original_move.db_symbol)
          power = Z_MOVES_POWER_EXCEPTIONS[@original_move.db_symbol]
        else
          case original_power
          when 0..59
            power = 100
          when 60..69
            power = 120
          when 70..79
            power = 140
          when 80..89
            power = 160
          when 90..99
            power = 175
          when 100..109
            power = 180
          when 110..119
            power = 185
          when 120..129
            power = 190
          when 130..139
            power = 195
          else
            power = 200
          end
        end

        log_data("power = #{power} # after #{self.class} real_base_power")
        power
      end

      # Internal procedure of the move
      # @param user [PFM::PokemonBattler]
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @note resets the user's moveset to the original and decreases the original move's PP
      def proceed_internal(user, targets)
        super(user, targets)

        z_move_position = find_z_move_position(user)
        user.original_moveset[z_move_position].pp -= 1
        user.original_moveset[z_move_position].pp -= 1 if @logic.foes_of(user).any? { |foe| foe.alive? && foe.has_ability?(:pressure) }

        user.original_moveset.map.with_index do |move, i|
          user.moveset[i] = Battle::Move[move.symbol].new(move.db_symbol, move.pp, move.ppmax, @scene)
        end
      end

      # Find the Z-Move position in the moveset of the Pokemon
      # @param pokemon [PFM::PokemonBattler]
      # @return [Integer]
      def find_z_move_position(pokemon)
        return 0 if pokemon.move_history.empty?

        pokemon.moveset.each_with_index do |move, i|
          return i if move && move.id == pokemon.move_history.last.move.id && move.pp == 0
        end
        return 0
      end
    end

    Move.register(:s_z_move, ZMove)
  end
end
