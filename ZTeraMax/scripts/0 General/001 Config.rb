module ProjectCompilation
  module DataBuilder
    module_function

    # alias default_ensure_config_is_built ensure_config_is_built
    def ensure_config_is_built
      Configs.states
      Configs.stats
      Configs.window
      Configs.scene_title_config
      Configs.credits_config
      Configs.save_config
      Configs.devices
      Configs.graphic
      Configs.infos
      Configs.display
      Configs.language
      Configs.settings
      Configs.texts
      Configs.z_tera_max
    end
  end
end

module Configs
  KEY_TRANSLATIONS[:useBuiltinMoveNameSlice] = :use_slice_name
  KEY_TRANSLATIONS[:defaultGigantamaxChance] = :default_gigantamax_chance

  module Project
    class ZTeraMax
      # if the move name should be sliced using the plugin's method
      # @return [Boolean]
      attr_accessor :use_slice_name

      # The default chance to generate a Pokémon with the gigantamax factor
      # @return [Integer] Between 0 and 100
      attr_accessor :default_gigantamax_chance
    end
  end

  # @!method self.z_tera_max
  #   @return [Project::ZTeraMax]
  register(:z_tera_max, 'z_tera_max_config', :json, false, Project::ZTeraMax)
end

module PSDKEditor
  def convert_z_tera_max_settings
    return if File.exist?(File.join(ROOT_CONFIGS, 'z_tera_max_config.json'))

    data_z_tera_max = { klass: 'Configs::Project::ZTeraMax' }
    data_z_tera_max[:useBuiltinMoveNameSlice] = PSDK_CONFIG.use_slice_name
    data_z_tera_max[:defaultGigantamaxChance] = PSDK_CONFIG.default_gigantamax_chance
    File.write(File.join(ROOT_CONFIGS, 'z_tera_max_config.json'), JSON.pretty_generate(data_z_tera_max))
  end
end
