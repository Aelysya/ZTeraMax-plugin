module BattleUI
  class PokemonSprite < ShaderedSprite
    module DynamaxPlugin
      # Pokemon sprite zoom
      # @return [Integer]
      def sprite_zoom
        return 2 if @pokemon.effects.has?(:dynamaxed)

        super
      end

      # Update the sprite
      def update
        super
        shader.set_float_uniform('color', [0.84, 0.07, 0.33, 0.5]) if @pokemon.effects.has?(:dynamaxed)
      end

      # Creates the deflating animation after dynamax expires
      def deflate_animation
        ya = Yuki::Animation
        animation = ya.send_command_to(self, :zoom=, 1)

        size_animation = Yuki::Animation::ScalarAnimation.new(1, self, :zoom=, 2, 1)

        color_updater = proc do |alpha|
          shader.set_float_uniform('color', [0.84, 0.07, 0.33] + [alpha])
        end

        color_animation = Yuki::Animation::ScalarAnimation.new(1, color_updater, :call, 0.5, 0)
        size_animation.parallel_add(color_animation)

        animation.play_before(size_animation)
        animation.start
        animation_handler[:deflate] = animation
      end
    end
    prepend DynamaxPlugin
  end
end
