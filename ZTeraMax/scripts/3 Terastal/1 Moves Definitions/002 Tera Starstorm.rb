module Battle
  class Move
    class TeraStarstorm < Basic
      # Function that deals the damage to the pokemon, hits all adjacent foes if the user is terastallized
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_damage(user, actual_targets)
        return super unless user.terastallized

        super(user, @logic.adjacent_foes_of(user))
      end

      # Is the skill physical?
      # @return [Boolean]
      def physical?
        return @physical.nil? ? super : @physical
      end

      # Is the skill special?
      # @return [Boolean]
      def special?
        return @special.nil? ? super : @special
      end

      # Get the types of the move with 1st type being affected by effects
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Array<Integer>] list of types of the move
      def definitive_types(user, target)
        return super unless user.terastallized

        return [user.tera_type]
      end

      # Return the current type of the move
      # @return [Integer]
      def type
        return super unless @user&.terastallized

        data_type(@user.tera_type).id
      end
    end
    Move.register(:s_tera_starstorm, TeraStarstorm)
  end
end
