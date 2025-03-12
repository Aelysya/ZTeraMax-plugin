module BattleUI
  class SkillChoice < GenericChoice
    module SkillChoiceZTeraMaxPlugin
      # Create a new SkillChoice UI
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def initialize(viewport, scene)
        @z_move_enabled = false
        @dynamax_enabled = false
        super(viewport, scene)
      end

      # Refresh the move buttons
      def refresh_skill_buttons
        @info.data = @pokemon
        @buttons.each do |button|
          button.data = @pokemon
        end
      end

      # Cancel the player choice
      def choice_cancel
        super
        @scene.logic.reset_to_original_moveset(@pokemon) if @pokemon.effects.has?(:z_power)
      end
    end

    prepend SkillChoiceZTeraMaxPlugin

    class MoveButton < UI::SpriteStack
      private

      alias default_create_sprites create_sprites
      # Create the buttons sprites
      def create_sprites
        @background = add_sprite(0, 0, 'battle/types', 1, each_data_type.size, type: SpriteSheet)
        @text = add_text(28, 6, 0, 16, Configs.z_tera_max.use_slice_name ? :sliced_name : :name, color: 10, type: UI::SymText)
      end
    end

    class SpecialButton < UI::SpriteStack
      module SpecialButtonZTeraMaxPlugin
        BUTTON_TEXT = { descr: 'Description', mega: 'Mega evolution', z_move: 'Z-Move', dynamax: 'Dynamax' }

        # Update the special button content
        # @param mechanic [Boolean]
        def refresh(mechanic = false)
          @text.text = BUTTON_TEXT[@type]
          @background.set_bitmap(mechanic ? 'battle/button_mega_activated' : 'battle/button_mega', :interface) if @type == :mega
          @background.set_bitmap(mechanic ? 'battle/button_zmove_activated' : 'battle/button_zmove', :interface) if @type == :z_move
          @background.set_bitmap(mechanic ? 'battle/button_dynamax_activated' : 'battle/button_dynamax', :interface) if @type == :dynamax
        end
      end

      prepend SpecialButtonZTeraMaxPlugin

      NO_DYNAMAX_POKEMON = %i[zacian zamazenta eternatus]
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
          when :z_move
            @scene.logic.z_move.can_pokemon_use_z_move?(pokemon)
          when :dynamax
            @scene.logic.dynamax.can_pokemon_dynamax?(pokemon) && !NO_DYNAMAX_POKEMON.include?(pokemon.db_symbol)
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
            @type == :z_move && @scene.logic.z_move.can_pokemon_use_z_move?(@data) ||
            @type == :dynamax && @scene.logic.dynamax.can_pokemon_dynamax?(@data)
          ))
          )
      end
    end

    class SubChoice < UI::SpriteStack
      module SubChoiceZTeraMaxPlugin
        # Reset the sub choice
        def reset
          @z_move_button.refresh(@choice.z_move_enabled)
          @dynamax_button.refresh(@choice.dynamax_enabled)
          super
        end

        private

        def action_y
          return $game_system.se_play($data_system.buzzer_se) unless @mega_button.visible || @z_move_button.visible || @dynamax_button.visible

          if @mega_button.visible
            @choice.mega_enabled = !@choice.mega_enabled
            @mega_button.refresh(@choice.mega_enabled)
          end

          if @z_move_button.visible
            @choice.z_move_enabled = !@choice.z_move_enabled
            @z_move_button.refresh(@choice.z_move_enabled)
            @scene.logic.z_move.update_moveset(@choice.pokemon, @choice.z_move_enabled)
            @choice.refresh_skill_buttons
          end

          if @dynamax_button.visible
            @choice.dynamax_enabled = !@choice.dynamax_enabled
            @dynamax_button.refresh(@choice.dynamax_enabled)
            @scene.logic.dynamax.update_moveset(@choice.pokemon, @choice.dynamax_enabled)
            @choice.refresh_skill_buttons
          end

          $game_system.se_play($data_system.decision_se)
        end
      end

      prepend SubChoiceZTeraMaxPlugin

      alias default_create_special_buttons create_special_buttons
      def create_special_buttons
        @z_move_button = add_sprite(2, 183, NO_INITIAL_IMAGE, @scene, :z_move, type: SpecialButton)
        @dynamax_button = add_sprite(2, 183, NO_INITIAL_IMAGE, @scene, :dynamax, type: SpecialButton)
        default_create_special_buttons
      end
    end
  end
end
