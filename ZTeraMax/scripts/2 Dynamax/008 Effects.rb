module Battle
  module Effects
    class Dynamaxed < PokemonTiedEffectBase
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :dynamaxed
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
