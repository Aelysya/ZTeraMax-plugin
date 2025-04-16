module Battle
  class Move
    class TeraBlast < Basic
      # Method calculating the damages done by the actual move
      # @note : I used the 4th Gen formula : https://www.smogon.com/dp/articles/damage_formula
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @note The formula is the following:
      #       (((((((Level * 2 / 5) + 2) * BasePower * [Sp]Atk / 50) / [Sp]Def) * Mod1) + 2) *
      #         CH * Mod2 * R / 100) * STAB * Type1 * Type2 * Mod3)
      # @return [Integer]
      def damages(user, target)
        return super unless user.terastallized

        raw_atk = (user.atk_basis * user.atk_modifier).floor
        raw_ats = (user.ats_basis * user.ats_modifier).floor
        @physical = raw_atk > raw_ats
        @special = !@physical
        log_data("Tera Blast's category: #{@physical ? :physical : :special}")

        return super
      end

      # Is the skill physical?
      # @return [Boolean]
      def physical?
        return false unless user.terastallized

        return @physical.nil? ? super : @physical
      end

      # Is the skill special?
      # @return [Boolean]
      def special?
        return true unless user.terastallized

        return @special.nil? ? super : @special
      end

      # Get the types of the move with 1st type being affected by effects
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Array<Integer>] list of types of the move
      def definitive_types(user, target)
        return super unless user.terastallized

        return user.tera_type
      end
    end
    Move.register(:s_tera_blast, TeraBlast)
  end
end
