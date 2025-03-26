module PFM
  class Pokemon
    module DynamaxPlugin
      # @return [Integer] Dynamax level of the Pokémon between 0 and 10
      attr_accessor :dynamax_level

      # @return [Boolean] If the Pokémon has the Gigantamax factor
      attr_accessor :gigantamax_factor

      # Create a new Pokemon with specific parameters
      # @param id [Integer, Symbol] ID of the Pokemon in the database
      # @param level [Integer] level of the Pokemon
      # @param force_shiny [Boolean] if the Pokemon have 100% chance to be shiny
      # @param no_shiny [Boolean] if the Pokemon have 0% chance to be shiny (override force_shiny)
      # @param form [Integer] Form index of the Pokemon (-1 = automatic generation)
      # @param opts [Hash] Hash describing optional value you want to assign to the Pokemon
      # @option opts [String] :given_name Nickname of the Pokemon
      # @option opts [Integer, Symbol] :captured_with ID of the ball used to catch the Pokemon
      # @option opts [Integer] :captured_in ID of the zone where the Pokemon was caught
      # @option opts [Integer, Time] :captured_at Time when the Pokemon was caught
      # @option opts [Integer] :captured_level Level of the Pokemon when it was caught
      # @option opts [Integer] :egg_in ID of the zone where the egg was layed/found
      # @option opts [Integer, Time] :egg_at Time when the egg was layed/found
      # @option opts [Integer, String] :gender Forced gender of the Pokemon
      # @option opts [Integer] :nature Nature of the Pokemon
      # @option opts [Array<Integer>] :stats IV array ([hp, atk, dfe, spd, ats, dfs])
      # @option opts [Array<Integer>] :bonus EV array ([hp, atk, dfe, spd, ats, dfs])
      # @option opts [Integer, Symbol] :item ID of the item the Pokemon is holding
      # @option opts [Integer, Symbol] :ability ID of the ability the Pokemon has
      # @option opts [Integer] :rareness Rareness of the Pokemon (0 = not catchable, 255 = always catchable)
      # @option opts [Integer] :loyalty Happiness of the Pokemon
      # @option opts [Array<Integer, Symbol>] :moves Current Moves of the Pokemon (0 = default)
      # @option opts [Array(Integer, Integer)] :memo_text Text used for the memo ([file_id, text_id])
      # @option opts [String] :trainer_name Name of the trainer that caught / got the Pokemon
      # @option opts [Integer] :trainer_id ID of the trainer that caught / got the Pokemon
      # @option opts [Boolean] :force_pokerus The Pokemon will be infected with pokerus
      # @option opts [Boolean] :force_pokerus_cured The Pokemon will be infected with the cured version of the pokerus (override force_pokerus)
      # @option opts [Integer] :strain If force_pokerus or force_pokerus_cured is true, this force the pokerus strain (clamped between 1 and 15)
      # @option opts [Boolean] :no_pokerus If the Pokemon has 0% chance to have pokerus (override force_pokerus and force_pokerus_cured)
      # @option opts [Integer] :dynamax_level Dynamax level of the Pokemon
      # @option opts [Boolean] :gigantamax_factor If the Pokemon has the Gigantamax factor
      def initialize(id, level, force_shiny = false, no_shiny = false, form = -1, opts = {})
        super
        dynamax_initialize(opts)
      end

      # Method that initialize the Dynamax values
      # @param opts [Hash] Hash describing optional value you want to assign to the Pokemon
      def dynamax_initialize(opts)
        @dynamax_level = opts[:dynamax_level] || 0

        @gigantamax_factor = if db_symbol == :eternatus
                               true
                             else
                               opts[:gigantamax_factor] || rand(100) < Configs.z_tera_max.gigantamax_chance # 10% by default
                             end
      end
    end
    prepend DynamaxPlugin
  end
end
