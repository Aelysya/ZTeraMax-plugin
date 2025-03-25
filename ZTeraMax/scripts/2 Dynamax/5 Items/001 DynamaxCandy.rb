module PFM
  module ItemDescriptor
    # Specific case dynamax_candy
    define_chen_prevention(:dynamax_candy) { $game_temp.in_battle }

    define_on_creature_usability(:dynamax_candy) do |_item, creature|
      next false if creature.egg?
      next false if creature.db_symbol == :shedinja

      next creature.dynamax_level.nil? || (creature.dynamax_level + 1) <= 10
    end

    define_on_creature_use(:dynamax_candy) do |_item, creature, _scene|
      creature.dynamax_level = creature.dynamax_level.nil? ? 1 : creature.dynamax_level + 1
      Audio.me_play(*LVL_SOUND)
      $scene.display_message_and_wait(parse_text_with_pokemon(20_000, 7, creature, PFM::Text::NUM3[0] => creature.dynamax_level.to_s))
    end
  end
end
