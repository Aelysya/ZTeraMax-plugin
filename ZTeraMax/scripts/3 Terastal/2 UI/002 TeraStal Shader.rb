Shader.register(:tera_shader, 'graphics/shaders/tera.frag', color_process: true)
module TeraShaderLoader
  TERA_COLOR = Color.new(0, 0, 255, 255)

  def load_shader_properties(creature)
    shader.set_float_uniform('uTeraColor', TERA_COLOR.dup) if @__csl_shader_id == :tera_shader
    shader.set_float_uniform('uResolution', [96.0, 96.0]) if @__csl_shader_id == :tera_shader
  end

  def find_shader_id(creature)
    return :tera_shader if creature.terastallized

    super
  end
end
BattleUI::PokemonSprite.prepend(TeraShaderLoader)
