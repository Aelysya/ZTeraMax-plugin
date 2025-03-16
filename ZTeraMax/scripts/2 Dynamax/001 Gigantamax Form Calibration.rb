module PFM
  class Pokemon
    %i[
      venusaur charizard blastoise butterfree pikachu meowth machamp
      gengar kingler lapras eevee snorlax garbodor melmetal rillaboom
      cinderace inteleon corviknight orbeetle drednaw coalossal flapple
      appletun sandaconda centiskorch hatterene grimmsnarl
      alcremie copperaja duraludon eternatus
    ].each do |species|
      FORM_CALIBRATE[species] = proc { |reason| @form = reason == :gigantamax ? 40 : 0 }
    end

    # Determine the gigantamax form for Urshifu and Toxtricity
    # @param reason [Symbol]
    def dual_gigantamax_form(reason)
      if reason == :gigantamax
        return 40 if @form == 0
        return 41 if @form == 1
      end

      return 0 if @form == 40

      return 1
    end

    FORM_CALIBRATE[:urshifu] = FORM_CALIBRATE[:toxtricity] = proc { |reason| @form = dual_gigantamax_form(reason) }
  end
end
