module PFM
  class Pokemon
    # Determine the form of Ogerpon
    # @param reason [Symbol]
    def ogerpon_form(reason)
      base_form = OGERPONMASK.index(item_db_symbol).to_i
      return base_form + 4 if reason == :terastal

      return base_form
    end

    # Determine the form of Terapagos
    # @param reason [Symbol]
    def terapagos_form(reason)
      return 1 if reason == :battle
      return 2 if reason == :terastal

      return 0
    end

    FORM_CALIBRATE[:terpagos] = proc { |reason| @form = terapagos_form(reason) }
    FORM_CALIBRATE[:ogerpon] = proc { |reason| @form = ogerpon_form(reason) }
  end
end
