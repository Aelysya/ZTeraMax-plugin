module Battle
  class Move
    module MoveZMovePlugin
      # if the move is Z-empowered, used for status moves bonus effects
      # @return [Boolean]
      attr_accessor :is_z

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      def initialize(db_symbol, pp, ppmax, scene)
        super(db_symbol, pp, ppmax, scene)
        @is_z = false
      end

      # Show the move usage message
      # @param user [PFM::PokemonBattler] user of the move
      def usage_message(user)
        @scene.visual.hide_team_info
        pre_z_move_message(user) if user.effects.has?(:z_power) && @is_z
        message = parse_text_with_pokemon(8999 - Studio::Text::CSV_BASE, 12, user, PFM::Text::PKNAME[0] => user.given_name, PFM::Text::MOVE[0] => name)
        scene.display_message_and_wait(message)
        PFM::Text.reset_variables
      end

      # Display messages before using a Z-Move
      # @return [String]
      def pre_z_move_message(user)
        @scene.display_message_and_wait(parse_text_with_pokemon(20_000, 0, user, PFM::Text::PKNICK[0] => user.given_name))
        @scene.display_message_and_wait(parse_text_with_pokemon(20_000, 1, user, PFM::Text::PKNICK[0] => user.given_name))
      end

      # Get the move name sliced to fit in the move button, also add a 'Z' affix if the move is a status Z-Move
      # @return [String]
      def sliced_name
        processed_name = name
        processed_name = parse_text(20_000, 2, PFM::Text::MOVE[0] => name) if @is_z && status?

        return processed_name if processed_name.size <= 15

        return processed_name.slice(0..12) << '...'
      end
    end

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
        core_enforcer: 140
      }

      # These move have 0 base power in database, but have a specific power when used with a Z-Crystal
      # @note Hard Press is a gen 9 move so it isn't documented yet. Assuming its power follows the standard formula, at 100% potential (100 bp).
      VARIABLE_POWER_Z_MOVES = {
        electro_ball: 160,
        gyro_ball: 160,
        endeavor: 160,
        final_gambit: 180,
        frustration: 160,
        return: 160,
        heat_crash: 160,
        heavy_slam: 160,
        natural_gift: 160,
        punishment: 160,
        fissure: 180,
        guillotine: 180,
        horn_drill: 180,
        sheer_cold: 180,
        crush_grip: 190,
        wring_out: 190,
        hard_press: 180
      }

      # Calculates the real base power of a move considering Z-Move exceptions and original move power.
      #
      # @param user [PFM::PokemonBattler] The user of the move.
      # @param target [PFM::PokemonBattler] The target of the move.
      # @return [Integer] The calculated base power of the move.
      # @see https://bulbapedia.bulbagarden.net/wiki/Z-Move#Power
      # The calculated power is then logged and returned.
      def real_base_power(_user, _target)
        z_power = if Z_MOVES_POWER_EXCEPTIONS.key?(@original_move.db_symbol)
                    Z_MOVES_POWER_EXCEPTIONS[@original_move.db_symbol]
                  elsif @original_move.base_power == 0 && VARIABLE_POWER_Z_MOVES.key?(@original_move.db_symbol)
                    VARIABLE_POWER_Z_MOVES[@original_move.db_symbol]
                  else
                    case @original_move.base_power
                    when 0..59 then 100
                    when 60..69 then 120
                    when 70..79 then 140
                    when 80..89 then 160
                    when 90..99 then 175
                    when 100..109 then 180
                    when 110..119 then 185
                    when 120..129 then 190
                    when 130..139 then 195
                    else 200
                    end
                  end

        log_data("z_power = #{z_power} # after #{self.class} real_base_power")
        return z_power
      end
    end
    Move.register(:s_z_move, ZMove)

    class GuardianOfAlola < Basic
      def damages(user, target)
        @critical = false
        @effectiveness = 1
        log_data("Forced HP Move: #{(target.hp / 4 * 3).clamp(1, Float::INFINITY)} HP")
        return (target.hp / 4 * 3).clamp(1, Float::INFINITY)
      end
    end
    Move.register(:s_guardian_of_alola, GuardianOfAlola)

    class GenesisSupernova < Basic
      # Sets terrain to psychic terrain
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        logic.fterrain_change_handler.fterrain_change_with_process(:psychic_terrain, 5)
      end
    end
    Move.register(:s_genesis_supernova, GenesisSupernova)
  end
end
