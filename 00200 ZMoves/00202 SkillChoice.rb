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
        @buttons.map do |button|
          button.data = @pokemon
          log_data(button.data)
        end
      end
    end

    prepend SkillChoiceZMovePlugin

    class SpecialButton < UI::SpriteStack
      module SpecialButtonZMovePlugin
        # Update the special button content
        # @param mechanic [Boolean]
        def refresh(mechanic = false)
          @text.text =
            case @type
            when :descr
              'Description'
            when :mega
              'Mega evolution'
            when :zmove
              'Z-Move'
            end
          @background.set_bitmap(mechanic ? 'battle/button_mega_activated' : 'battle/button_mega', :interface) if @type != :descr
        end
      end

      prepend SpecialButtonZMovePlugin

      alias_method :default_data, :data=
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

      alias_method :default_visible, :visible=
      # Set the visibility of the button
      # @param visible [Boolean]
      def visible=(visible)
        super(visible &&
          (@type == :descr ||
          (@data &&
            (@scene.logic.mega_evolve.can_pokemon_mega_evolve?(@data) ||
            @scene.logic.z_move.can_pokemon_use_z_move?(@data)))
          ))
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
            @scene.logic.z_move.update_movepool(@choice.pokemon, @choice.zmove_enabled)
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
