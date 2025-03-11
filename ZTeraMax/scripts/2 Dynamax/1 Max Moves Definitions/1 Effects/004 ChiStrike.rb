module Battle
  module Effects
    class ChiStrike < PokemonTiedEffectBase
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :chi_strike
      end
    end
  end

  class Logic
    module DynamaxPlugin
      # Calculate the critical count (to get the right critical propability)
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler]
      # @param initial_critical_count [Integer] Initial critical count of the move
      # @return [Integer]
      def calc_critical_count(user, target, initial_critical_count)
        return 0 if user.can_be_lowered_or_canceled?(NO_CRITICAL_ABILITIES.include?(target.battle_ability_db_symbol))

        critical_count = super
        log_data('Crit count before: ' << critical_count.to_s)
        user.effects.each do |effect|
          critical_count += 1 if effect.name == :chi_strike
        end
        log_data('Crit count after: ' << critical_count.to_s)
        return critical_count
      end
    end

    prepend DynamaxPlugin
  end
end
