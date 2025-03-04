module Battle
  class Move
    module ZTeraMaxPlugin
      # if the move is Z-empowered
      # @return [Boolean]
      attr_accessor :is_z

      # if the move is a Max Move
      # @return [Boolean]
      attr_accessor :is_max

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      def initialize(db_symbol, pp, ppmax, scene)
        super(db_symbol, pp, ppmax, scene)
        @is_z = false
        @is_max = false
      end

      # Show the move usage message
      # @param user [PFM::PokemonBattler] user of the move
      def usage_message(user)
        @scene.visual.hide_team_info
        pre_z_move_message(user) if user.effects.has?(:z_power) && @is_z
        message = parse_text_with_pokemon(8999 - Studio::Text::CSV_BASE, 12, user, PFM::Text::PKNAME[0] => user.given_name, PFM::Text::MOVE[0] => name)
        scene.display_message_and_wait(message)
        PFM::Text.reset_variables
      end

      # Display messages before using a Z-Move
      # @return [String]
      def pre_z_move_message(user)
        @scene.display_message_and_wait(parse_text_with_pokemon(20_000, 0, user, PFM::Text::PKNICK[0] => user.given_name))
        @scene.display_message_and_wait(parse_text_with_pokemon(20_000, 1, user, PFM::Text::PKNICK[0] => user.given_name))
      end

      # Return the name of the skill
      def name
        return parse_text(20_000, 2, PFM::Text::MOVE[0] => super) if @is_z && status?

        super
      end

      # Get the move name sliced to fit in the move button, also add a 'Z' affix if the move is a status Z-Move
      # @return [String]
      def sliced_name
        return name if name.size <= 15

        return name.slice(0..12) << '...'
      end
    end

    prepend ZTeraMaxPlugin
  end
end
