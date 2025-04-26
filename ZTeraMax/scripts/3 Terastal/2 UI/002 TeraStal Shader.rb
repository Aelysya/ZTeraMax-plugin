Shader.register(:tera_shader, 'graphics/shaders/tera.frag', color_process: true)
module TeraShaderLoader
  TERA_COLORS = {
    normal: Color.new(148, 143, 127, 255),
    fire: Color.new(222, 108, 47, 255),
    water: Color.new(64, 141, 191, 255),
    electric: Color.new(255, 189, 24, 255),
    grass: Color.new(90, 189, 99, 255),
    ice: Color.new(83, 192, 196, 255),
    fighting: Color.new(197, 62, 69, 255),
    poison: Color.new(176, 86, 155, 255),
    ground: Color.new(201, 148, 87, 255),
    flying: Color.new(124, 123, 186, 255),
    psychic: Color.new(217, 108, 170, 255),
    bug: Color.new(144, 181, 51, 255),
    rock: Color.new(158, 120, 74, 255),
    ghost: Color.new(110, 86, 163, 255),
    dragon: Color.new(87, 85, 166, 255),
    steel: Color.new(135, 140, 153, 255),
    dark: Color.new(89, 89, 89, 255),
    fairy: Color.new(232, 121, 160, 255),
    stellar: Color.new(166, 230, 222, 255)
  }

  def load_shader_properties(creature)
    shader.set_float_uniform('uTeraColor', TERA_COLORS[data_type(creature.tera_type).db_symbol]) if @__csl_shader_id == :tera_shader
    shader.set_float_uniform('uResolution', [96.0, 96.0]) if @__csl_shader_id == :tera_shader
  end

  def find_shader_id(creature)
    return :tera_shader if creature.terastallized

    super
  end
end
BattleUI::PokemonSprite.prepend(TeraShaderLoader)
