module UI
  class Summary_Top < SpriteStack
    module MemoZTeraMaxPlugin
      # Set the Pokemon shown
      # @param pokemon [PFM::Pokemon]
      def data=(pokemon)
        @gigantamax.visible = pokemon.gigantamax_factor
        super
      end

      def init_sprite
        super
        @gigantamax = create_gigantamax
      end

      # @return [Sprite]
      def create_gigantamax
        push(23, 25, 'gigantamax_icon')
      end
    end

    prepend MemoZTeraMaxPlugin
  end
end
