module BattleUI
  class SkillChoice < GenericChoice
    module SkillChoiceZTeraMaxPlugin
      # Create a new SkillChoice UI
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def initialize(viewport, scene)
        @z_move_enabled = false
        @dynamax_enabled = false
        @terastal_enabled = false
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
        @pokemon.reset_to_original_moveset if @pokemon.effects.has?(:z_power)
        @pokemon.reset_to_original_moveset if @pokemon.effects.has?(:dynamaxed) && !@pokemon.dynamaxed
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
        # Texts of the special buttons
        BUTTON_TEXT = { descr: 'Description', mega: 'Mega evolution', z_move: 'Z-Move', dynamax: 'Dynamax', terastal: 'Terastal' }

        # Backgrounds of the special buttons
        BUTTON_BACKGROUND = {
          mega: ['battle/button_mega', 'battle/button_mega_activated'],
          z_move: ['battle/button_zmove', 'battle/button_zmove_activated'],
          dynamax: ['battle/button_dynamax', 'battle/button_dynamax_activated'],
          terastal: ['battle/button_terastal', 'battle/button_terastal_activated']
        }

        # Update the special button content
        # @param mechanic [Boolean]
        def refresh(mechanic = false)
          @text.text = BUTTON_TEXT[@type]

          if (backgrounds = BUTTON_BACKGROUND[@type])
            @background.set_bitmap(backgrounds[mechanic ? 1 : 0], :interface)
          end
        end
      end
      prepend SpecialButtonZTeraMaxPlugin

      NO_DYNAMAX_POKEMON = %i[zacian zamazenta]
      alias default_data data=
      # Set the data of the button
      # @param pokemon [PFM::PokemonBattler]
      def data=(pokemon)
        super

        terastal_enabled = $game_switches[Configs.z_tera_max.terastal_enabled_switch]
        # If Terastal is enabled, Dynamax is disabled
        dynamax_enabled = $game_switches[Configs.z_tera_max.dynamax_enabled_switch] && !terastal_enabled
        self.visible =
          case @type
          when :descr
            true
          when :mega
            @scene.logic.mega_evolve.can_pokemon_mega_evolve?(pokemon)
          when :z_move
            @scene.logic.z_move.can_pokemon_use_z_move?(pokemon)
          when :dynamax
            @scene.logic.dynamax.can_pokemon_dynamax?(pokemon) && !NO_DYNAMAX_POKEMON.include?(pokemon.db_symbol) && dynamax_enabled
          when :terastal
            @scene.logic.terastal.can_pokemon_terastal?(pokemon) && terastal_enabled
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
            @type == :dynamax && @scene.logic.dynamax.can_pokemon_dynamax?(@data) ||
            @type == :terastal && @scene.logic.terastal.can_pokemon_terastal?(@data)
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
          @terastal_button.refresh(@choice.terastal_enabled)
          super
        end

        private

        def action_y
          unless @mega_button.visible || @z_move_button.visible || @dynamax_button.visible || @terastal_button.visible
            return $game_system.se_play($data_system.buzzer_se)
          end

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

          if @terastal_button.visible
            @choice.terastal_enabled = !@choice.terastal_enabled
            @terastal_button.refresh(@choice.terastal_enabled)
          end

          $game_system.se_play($data_system.decision_se)
        end

        def create_special_buttons
          @z_move_button = add_sprite(2, 183, UI::SpriteStack::NO_INITIAL_IMAGE, @scene, :z_move, type: SpecialButton)
          @dynamax_button = add_sprite(2, 183, UI::SpriteStack::NO_INITIAL_IMAGE, @scene, :dynamax, type: SpecialButton)
          @terastal_button = add_sprite(2, 183, UI::SpriteStack::NO_INITIAL_IMAGE, @scene, :terastal, type: SpecialButton)
          super
        end
      end
      prepend SubChoiceZTeraMaxPlugin
    end
  end
end
