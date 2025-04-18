module Battle
  class Move
    module TerastalPlugin
      # STAB calculation
      # @param user [PFM::PokemonBattler] user of the move
      # @param types [Array<Integer>] list of definitive types of the move
      # @return [Numeric]
      def calc_stab(user, types)
        super unless user.terastallized

        has_tera_stab = types.any? { |type| user.tera_type == type }
        has_regular_stab = types.any? { |type| user.type1 == type || user.type2 == type || user.type3 == type }

        if has_tera_stab && has_regular_stab
          return 2.25 if user.has_ability?(:adaptability)

          return 2
        end

        return 2 if has_tera_stab && user.has_ability?(:adaptability)
        return 1.5 if has_tera_stab || has_regular_stab

        return 1
      end

      private

      # List of methods that should be ignored for base power boosting when terastallized
      IGNORED_BE_METHODS = %i[s_multi_hit s_2hits s_eruption s_wring_out s_return s_flail s_gyro_ball s_beat_up s_fling
                              s_electro_ball s_frustration s_low_kick s_heavy_slam s_psywave s_hp_eq_level s_hard_press
                              s_magnitude s_trump_card s_stored_power s_split_up s_present s_natural_gift]

      # Base power calculation
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Integer]
      def calc_base_power(user, target)
        return super unless user.terastallized

        base_power = super
        return 60 unless base_power >= 60 || IGNORED_BE_METHODS.include?(be_method)
      end
    end
    prepend TerastalPlugin
  end
end
