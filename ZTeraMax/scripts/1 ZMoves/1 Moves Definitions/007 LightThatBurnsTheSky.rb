module Battle
  class Move
    class LightThatBurnsTheSky < ZMove
      # Is the skill physical ?
      # @return [Boolean]
      def physical?
        best_stat = original_launcher.atk > original_launcher.ats
        return best_stat
      end

      # Is the skill special ?
      # @return [Boolean]
      def special?
        return !physical?
      end
    end
    Move.register(:s_light_that_burns_the_sky, LightThatBurnsTheSky)
  end
end
