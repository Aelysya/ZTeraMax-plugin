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

      # Modified method calculating the damages done by the actual move by adding Z-move power calculation if target is protected
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def damages(user, target)
        # rubocop:disable Layout/ExtraSpacing
        # rubocop:disable Style/Semicolon
        # rubocop:disable Style/SpaceBeforeSemicolon
        log_data("# damages(#{user}, #{target}) for #{db_symbol}")
        # Reset the effectiveness
        @effectiveness = 1
        @critical = logic.calc_critical_hit(user, target, critical_rate)                   ; log_data("@critical = #{@critical} # critical_rate = #{critical_rate}")
        damage = user.level * 2 / 5 + 2                                                    ; log_data("damage = #{damage} # #{user.level} * 2 / 5 + 2")
        damage = (damage * calc_base_power(user, target)).floor                            ; log_data("damage = #{damage} # after calc_base_power")
        damage = (damage * calc_sp_atk(user, target)).floor / 50                           ; log_data("damage = #{damage} # after calc_sp_atk / 50")
        damage = (damage / calc_sp_def(user, target)).floor                                ; log_data("damage = #{damage} # after calc_sp_def")
        damage = (damage * calc_mod1(user, target)).floor + 2                              ; log_data("damage = #{damage} # after calc_mod1 + 2")
        damage = (damage * calc_ch(user, target)).floor                                    ; log_data("damage = #{damage} # after calc_ch")
        damage = (damage * calc_mod2(user, target)).floor                                  ; log_data("damage = #{damage} # after calc_mod2")
        damage *= logic.move_damage_rng.rand(calc_r_range)
        damage /= 100                                                                      ; log_data("damage = #{damage} # after rng")
        types = definitive_types(user, target)
        damage = (damage * calc_stab(user, types)).floor                                   ; log_data("damage = #{damage} # after stab")
        damage = (damage * calc_type_n_multiplier(target, :type1, types)).floor            ; log_data("damage = #{damage} # after type1")
        damage = (damage * calc_type_n_multiplier(target, :type2, types)).floor            ; log_data("damage = #{damage} # after type2")
        damage = (damage * calc_type_n_multiplier(target, :type3, types)).floor            ; log_data("damage = #{damage} # after type3")
        damage = (damage * calc_mod3(user, target)).floor                                  ; log_data("damage = #{damage} # after mod3")
        damage = (damage * calc_z_move(target)).floor                                      ; log_data("damage = #{damage} # after z_move")
        target_hp = target.effects.get(:substitute).hp if target.effects.has?(:substitute) && !user.has_ability?(:infiltrator) && !authentic?
        target_hp ||= target.hp
        damage = damage.clamp(1, target_hp)                                                ; log_data("damage = #{damage} # after clamp")

        return damage
        # rubocop:enable Layout/ExtraSpacing
        # rubocop:enable Style/Semicolon
        # rubocop:enable Style/SpaceBeforeSemicolon
      end

      # List of moves decreasing the Z-Moves damage to 25%
      DECREASING_DAMAGE_MOVES = %i[protect detect spiky_shield baneful_bunker burning_bulwark king_s_shield mat_block obstruct silk_trap]

      def calc_z_move(target)
        last_move = target.successful_move_history.last

        return 0.25 if last_move.current_turn? && DECREASING_DAMAGE_MOVES.include?(last_move.move.db_symbol)
        return 1
      end
    end

    Move.register(:s_z_move, ZMove)
  end
end
