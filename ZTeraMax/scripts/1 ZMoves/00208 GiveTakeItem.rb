module Util
  # Module adding the give / take item functionality to a scene
  module GiveTakeItem
    alias default_give givetake_give_item_update_state
    # Update the bag and pokemon state when giving an item
    # @param item1 [Integer] taken item
    # @param item2 [Integer] given item
    # @param pokemon [PFM::Pokemon] Pokemong getting the item
    def givetake_give_item_update_state(item1, item2, pokemon)
      if Z_CRYSTALS_IDS.key?(item2)
        pokemon.item_holding = Z_CRYSTALS_IDS[item2]
        $bag.add_item(item1, 1) unless item1 == 0 || Z_CRYSTALS_IDS.value?(item1)
      else
        default_give(item1, item2, pokemon)
      end
    end

    alias default_take givetake_take_item
    # Action of taking the item from the Pokemon
    # @param pokemon [PFM::Pokemon] pokemon we take item from
    # @yieldparam pokemon [PFM::Pokemon] block we call with pokemon before and after the form calibration
    def givetake_take_item(pokemon)
      item = pokemon.item_holding
      $bag.add_item(item, 1) unless Z_CRYSTALS_IDS.value?(item)
      pokemon.item_holding = 0
      yield(pokemon) if block_given?
      display_message(parse_text(23, 78, ::PFM::Text::PKNICK[0] => pokemon.given_name, ::PFM::Text::ITEM2[1] => data_item(item).name))
      return unless pokemon.form_calibrate # Form ajustment

      pokemon.hp = (pokemon.max_hp * pokemon.hp_rate).round
      yield(pokemon) if block_given?
      display_message(parse_text(22, 157, ::PFM::Text::PKNAME[0] => pokemon.given_name))
    end
  end
end
