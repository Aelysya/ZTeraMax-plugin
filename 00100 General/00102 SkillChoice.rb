module BattleUI
  class SkillChoice < GenericChoice
    module SkillChoiceZMovePlugin
      # Create a new SkillChoice UI
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def initialize(viewport, scene)
        @zmove_enabled = false
        super(viewport, scene)
      end

      def refresh_skill_buttons
        @info.data = @pokemon
        @buttons.each do |button|
          button.data = @pokemon
        end
      end
    end

    prepend SkillChoiceZMovePlugin

    class MoveButton < UI::SpriteStack
      private

      alias default_create_sprites create_sprites
      def create_sprites
        @background = add_sprite(0, 0, 'battle/types', 1, each_data_type.size, type: SpriteSheet)
        @text = add_text(28, 6, 0, 16, :sliced_name, color: 10, type: UI::SymText)
      end
    end

    class SpecialButton < UI::SpriteStack
      module SpecialButtonZMovePlugin
        BUTTON_TEXT = { descr: 'Description', mega: 'Mega evolution', zmove: 'Z-Move' }

        # Update the special button content
        # @param mechanic [Boolean]
        def refresh(mechanic = false)
          @text.text = BUTTON_TEXT[@type]
          @background.set_bitmap(mechanic ? 'battle/button_mega_activated' : 'battle/button_mega', :interface) if @type != :descr
        end
      end

      prepend SpecialButtonZMovePlugin

      alias default_data data=
      # Set the data of the button
      # @param pokemon [PFM::PokemonBattler]
      def data=(pokemon)
        super
        self.visible =
          case @type
          when :descr
            true
          when :mega
            @scene.logic.mega_evolve.can_pokemon_mega_evolve?(pokemon)
          when :zmove
            @scene.logic.z_move.can_pokemon_use_z_move?(pokemon)
          end
      end

      alias default_visible visible=
      # Set the visibility of the button
      # @param visible [Boolean]
      def visible=(visible)
        super(visible &&
          (@type == :descr ||
          (@data &&
            @type == :mega && @scene.logic.mega_evolve.can_pokemon_mega_evolve?(@data) ||
            @type == :zmove && @scene.logic.z_move.can_pokemon_use_z_move?(@data)
          ))
          )
      end
    end

    class SubChoice < UI::SpriteStack
      module SubChoiceZMovePlugin
        # Reset the sub choice
        def reset
          @zmove_button.refresh(@choice.zmove_enabled)
          super
        end

        private

        def action_y
          return $game_system.se_play($data_system.buzzer_se) unless @mega_button.visible || @zmove_button.visible

          if @mega_button.visible
            @choice.mega_enabled = !@choice.mega_enabled
            @mega_button.refresh(@choice.mega_enabled)
          end

          if @zmove_button.visible
            @choice.zmove_enabled = !@choice.zmove_enabled
            @zmove_button.refresh(@choice.zmove_enabled)
            @scene.logic.z_move.update_moveset(@choice.pokemon, @choice.zmove_enabled)
            @choice.refresh_skill_buttons
          end

          $game_system.se_play($data_system.decision_se)
        end
      end

      prepend SubChoiceZMovePlugin

      alias default_create_special_buttons create_special_buttons
      def create_special_buttons
        @zmove_button = add_sprite(2, 183, NO_INITIAL_IMAGE, @scene, :zmove, type: SpecialButton)
        default_create_special_buttons
      end
    end
  end
end
