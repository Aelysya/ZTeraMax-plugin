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

        # Double STAB
        if has_tera_stab && has_regular_stab
          return 2.25 if user.has_ability?(:adaptability) # During Terastalization, Adaptability only works on the Tera type

          return 2
        end

        # Simple STAB
        return 1.5 if has_tera_stab || has_regular_stab

        return 1
      end
    end
    prepend TerastalPlugin
  end
end
