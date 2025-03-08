module Battle
  module Effects
    class Dynamaxed < PokemonTiedEffectBase
      # Create a new Pokemon tied effect
      # @param logic [Battle::Logic]
      # @param pokemon [PFM::PokemonBattler]
      def initialize(logic, pokemon)
        super
        @counter = 3
      end

      # Get the name of the effect
      # @return [Symbol]
      def name
        return :dynamaxed
      end

      # Function called when the effect has been deleted from the effects handler
      def on_delete
        @pokemon.reset_to_original_moveset
      end

      # Function called when the effect has been deleted from the effects handler
      def on_switch_event(handler, who, with)
        kill
      end

      # Function called after damages were applied and when target died (post_damage_death)
      # @param handler [Battle::Logic::DamageHandler]
      # @param hp [Integer] number of hp (damage) dealt
      # @param target [PFM::PokemonBattler]
      # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
      # @param skill [Battle::Move, nil] Potential move used
      def on_post_damage_death(handler, hp, target, launcher, skill)
        kill
      end
    end

    class MaxGuard < Protect
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :max_guard
      end
    end
  end
end
