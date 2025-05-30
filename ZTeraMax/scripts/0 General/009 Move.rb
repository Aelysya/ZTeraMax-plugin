module Battle
  class Move
    module ZTeraMaxPlugin
      # Return the name of the skill
      # @note Add a 'Z' affix if the move is a status Z-Move
      def name
        return parse_text(20_000, 6, PFM::Text::MOVE[0] => data.name) if @is_z && status?

        super
      end

      # Get the move name sliced to fit in the move button, also add a 'Z' affix if the move is a status Z-Move
      # @return [String]
      def sliced_name
        return name if name.size < 15

        return name.slice(0..12) << '...'
      end

      # Checks if the move is trampling and does some damage through protect-like effects
      # @return [Boolean] If the move is trampling
      def trampling?
        return false
      end
    end
    prepend ZTeraMaxPlugin
  end
end
