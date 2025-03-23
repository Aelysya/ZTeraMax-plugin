module Battle
  module Effects
    # Implement the Protect effect
    class Protect < PokemonTiedEffectBase
      module ZTeraMaxPlugin
        # Function called when we try to check if the target evades the move
        # @param user [PFM::PokemonBattler]
        # @param target [PFM::PokemonBattler] expected target
        # @param move [Battle::Move]
        # @return [Boolean] if the target is evading the move
        def on_move_prevention_target(user, target, move)
          if trampling_move?(move)
            @logic.scene.display_message_and_wait(parse_text(20_000, 6, PFM::Text::PKNICK[0] => target.given_name))

            return false
          end

          super
        end

        # Give the move mod3 mutiplier (after everything)
        # @param user [PFM::PokemonBattler] user of the move
        # @param target [PFM::PokemonBattler] target of the move
        # @param move [Battle::Move] move
        # @return [Float, Integer] multiplier
        def mod3_multiplier(_user, target, move)
          return 1 if target != @pokemon
          return 1 unless trampling_move?(move)

          return 0.25
        end

        # Check if the move is a Z-Move or Max Move
        # @param move [Battle::Move]
        # @return [Boolean]
        def trampling_move?(move)
          return false if move.db_symbol == :gmax_one_blow || move.db_symbol == :gmax_rapid_flow
          return true if move.is_a?(Battle::Move::ZMove) || move.is_a?(Battle::Move::MaxMove)

          return false
        end
      end
      prepend ZTeraMaxPlugin
    end
  end
end
