module BattleUI
  class SkillChoice
    module SkillChoiceZMovePlugin
      # Create a new SkillChoice UI
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def initialize(viewport, scene)
        @zmove_enabled = false
        super(viewport, scene)
      end
    end

    prepend SkillChoiceZMovePlugin

    class SpecialButton
      module SpecialButtonZMovePlugin
        # alias default_refresh refresh
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

    class SubChoice
      module SubChoiceZMovePlugin
        # Reset the sub choice
        def reset
          @zmove_button.refresh(@choice.zmove_enabled)
          super
        end

        private

        def action_y
          return $game_system.se_play($data_system.buzzer_se) unless @mega_button.visible || @zmove_button.visible

          @choice.mega_enabled = !@choice.mega_enabled
          @mega_button.refresh(@choice.mega_enabled)
          @choice.zmove_enabled = !@choice.zmove_enabled
          @zmove_button.refresh(@choice.zmove_enabled)
          zmove_related_stuff(@choice.pokemon, @choice.zmove_enabled)
          $game_system.se_play($data_system.decision_se)
        end

        ZCRYSTALS = {
          firium_z: { type: :fire, physical: :inferno_overdrive, special: :inferno_overdrive2 },
          waterium_z: { type: :water, physical: :hydro_vortex, special: :hydro_vortex2 }
        }
        def zmove_related_stuff(pokemon, zcrystal_activated)
          return unless ZCRYSTALS.keys.include?(pokemon.item_db_symbol)

          if zcrystal_activated
            pokemon.moveset.map! do |move|
              next move unless data_type(move.type).db_symbol == ZCRYSTALS[pokemon.item_db_symbol][:type]
              next move if data_move(move.db_symbol).category == :status

              Battle::Move[:s_z_move].new(ZCRYSTALS[pokemon.item_db_symbol][data_move(move.db_symbol).category], @scene, move)
            end
          else
            pokemon.moveset.map!.with_index { |_, index| pokemon.original.moveset[index] }
          end
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
