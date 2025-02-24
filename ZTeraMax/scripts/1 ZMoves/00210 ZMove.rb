module Battle
  class Move
    module MoveZMovePlugin
      # if the move is Z-empowered
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
        pre_z_move_message(user) if @is_z
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

      # Get the move name sliced to fit in the move button, also add a 'Z' affixe if the move is a status Z-Move
      # @return [String]
      def sliced_name
        processed_name = name
        processed_name = parse_text(20_000, 2, PFM::Text::MOVE[0] => name) if @is_z && status?

        return processed_name if processed_name.size <= 15

        return processed_name.slice(0..12) << '...'
      end
    end

    class ZMove < Basic
      # List of move-copying moves that should not be reverted after using them as Z-Moves
      NO_REVERT_Z_MOVES = %i[mimic sketch]

      # Internal procedure of the move
      # @param user [PFM::PokemonBattler]
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      def proceed_internal(user, targets)
        super(user, targets)

        z_move_position = find_z_move_position(user)
        original_move = user.original_moveset[z_move_position]

        original_move.pp -= @logic.foes_of(user).any? { |foe| foe.alive? && foe.has_ability?(:pressure) } ? 2 : 1

        user.original_moveset.each_with_index do |move, i|
          user.moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene) unless NO_REVERT_Z_MOVES.include?(move.db_symbol)
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

    # Class managing type-specific Z-Moves
    class TypeZMove < ZMove
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
        return power
      end
    end
    Move.register(:s_type_z_move, TypeZMove)

    class GuardianOfAlola < ZMove
      def damages(user, target)
        @critical = false
        @effectiveness = 1
        log_data("Forced HP Move: #{(target.hp / 4 * 3).clamp(1, Float::INFINITY)} HP")
        return (target.hp / 4 * 3).clamp(1, Float::INFINITY)
      end
    end
    Move.register(:s_guardian_of_alola, GuardianOfAlola)

    class GenesisSupernova < ZMove
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
