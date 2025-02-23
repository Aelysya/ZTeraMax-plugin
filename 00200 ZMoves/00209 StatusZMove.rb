module Battle
  class Move
    # if the move is Z-empowered
    # @return [Boolean]
    attr_accessor :is_z

    module MoveZMovePlugin
      module_function

      # Create a new move
      # @param db_symbol [Symbol] db_symbol of the move in the database
      # @param pp [Integer] number of pp the move currently has
      # @param ppmax [Integer] maximum number of pp the move currently has
      # @param scene [Battle::Scene] current battle scene
      def initialize(db_symbol, pp, ppmax, scene)
        super(db_symbol, pp, ppmax, scene)
        @is_z = false
      end

      # rubocop:disable Layout/HashAlignment
      # rubocop:disable Naming/VariableNumber
      # List of status moves that have an effect when used with a Z-Crystal
      Z_STATUS_MOVES_EFFECTS = {
        # Attack
        tail_whip:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        leer:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        meditate:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        screech:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        sharpen:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        will_o_wisp: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        taunt:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        odor_sleuth: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        howl:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        bulk_up:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        power_trick: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        hone_claws:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        work_up:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        rototiller:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        topsy_turvy: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        laser_focus: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self) },
        splash:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 3, user, user, self) },

        # Defense
        growl:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        roar:           ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        poison_powder:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        toxic:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        harden:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        withdraw:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        reflect:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        poison_gas:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        spider_web:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        spikes:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        charm:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        pain_split:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        torment:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        feather_dance:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        tickle:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        block:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        toxic_spikes:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        aqua_ring:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        stealth_rock:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        defend_order:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        wide_guard:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        quick_guard:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        mat_block:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        noble_roar:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        flower_shield:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        grassy_terrain: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        fairy_lock:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        play_nice:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        spiky_shield:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        venom_drench:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        baby_doll_eyes: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        baneful_bunker: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        strength_sap:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },
        tearful_look:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self) },

        # Special Attack
        growth:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        confuse_ray:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        mind_reader:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        nightmare:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        sweet_kiss:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        teeter_dance:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        fake_tears:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        metal_sound:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        gravity:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        miracle_eye:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        embargo:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        telekinesis:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        soak:            ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        simple_beam:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        reflect_type:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        ion_deluge:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        electrify:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        gear_up:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        psychic_terrain: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        instruct:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self) },
        psycho_shift:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 2, user, user, self) },
        heal_block:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:ats, 2, user, user, self) },

        # Special Defense
        whirlwind:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        stun_spore:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        thunder_wave:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        light_screen:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        glare:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        mean_look:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        flatter:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        charge:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        wish:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        ingrain:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        mud_sport:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        cosmic_power:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        water_sport:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        wonder_room:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        magic_room:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        entrainment:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        crafty_shield: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        misty_terrain: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        confide:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        eerie_impulse: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        magnetic_flux: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        spotlight:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self) },
        magic_coat:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 2, user, user, self) },
        imprison:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 2, user, user, self) },
        captivate:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 2, user, user, self) },
        aromatic_mist: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 2, user, user, self) },
        powder:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:dfs, 2, user, user, self) },

        # Speed
        sing:             ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        supersonic:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        sleep_powder:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        string_shot:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        hypnosis:         ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        lovely_kiss:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        scary_face:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        lock_on:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        sandstorm:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        safeguard:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        encore:           ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        rain_dance:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        sunny_dance:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        hail:             ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        role_play:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        yawn:             ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        skill_swap:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        grass_whistle:    ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        gastro_acid:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        power_swap:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        guard_swap:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        worry_seed:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        guard_split:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        power_split:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        after_you:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        quash:            ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        sticky_web:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        electric_terrain: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        toxic_thread:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        speed_swap:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        aurora_veil:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self) },
        trick:            ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) },
        recycle:          ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) },
        snatch:           ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) },
        switcheroo:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) },
        ally_switch:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) },
        bestow:           ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) },

        # Accuracy
        mimic:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },
        defense_curl: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },
        focus_energy: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },
        sweet_scent:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },
        defog:        ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },
        trick_room:   ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },

        # Evasion
        sand_attack: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        smokescreen: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        kinesis:     ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        flash:       ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        detect:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        camouflage:  ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        lucky_chant: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },
        magnet_rise: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:eva, 1, user, user, self) },

        # All basic stats
        conversion:     ->(user, scene) { increase_all_stats(user, scene) },
        sketch:         ->(user, scene) { increase_all_stats(user, scene) },
        trick_or_treat: ->(user, scene) { increase_all_stats(user, scene) },
        forest_s_curse: ->(user, scene) { increase_all_stats(user, scene) },
        geomancy:       ->(user, scene) { increase_all_stats(user, scene) },
        happy_hour:     ->(user, scene) { increase_all_stats(user, scene) },
        celebrate:      ->(user, scene) { increase_all_stats(user, scene) },
        hold_hands:     ->(user, scene) { increase_all_stats(user, scene) },
        purify:         ->(user, scene) { increase_all_stats(user, scene) },

        # Reset decreased stats
        swords_dance:   ->(user, scene) { reset_decreased_stats(user, scene) },
        disable:        ->(user, scene) { reset_decreased_stats(user, scene) },
        leech_seed:     ->(user, scene) { reset_decreased_stats(user, scene) },
        agility:        ->(user, scene) { reset_decreased_stats(user, scene) },
        double_team:    ->(user, scene) { reset_decreased_stats(user, scene) },
        recover:        ->(user, scene) { reset_decreased_stats(user, scene) },
        minimize:       ->(user, scene) { reset_decreased_stats(user, scene) },
        barrier:        ->(user, scene) { reset_decreased_stats(user, scene) },
        amnesia:        ->(user, scene) { reset_decreased_stats(user, scene) },
        soft_boiled:    ->(user, scene) { reset_decreased_stats(user, scene) },
        spore:          ->(user, scene) { reset_decreased_stats(user, scene) },
        acid_armor:     ->(user, scene) { reset_decreased_stats(user, scene) },
        rest:           ->(user, scene) { reset_decreased_stats(user, scene) },
        substitute:     ->(user, scene) { reset_decreased_stats(user, scene) },
        cotton_spore:   ->(user, scene) { reset_decreased_stats(user, scene) },
        protect:        ->(user, scene) { reset_decreased_stats(user, scene) },
        perish_song:    ->(user, scene) { reset_decreased_stats(user, scene) },
        endure:         ->(user, scene) { reset_decreased_stats(user, scene) },
        swagger:        ->(user, scene) { reset_decreased_stats(user, scene) },
        milk_drink:     ->(user, scene) { reset_decreased_stats(user, scene) },
        attract:        ->(user, scene) { reset_decreased_stats(user, scene) },
        baton_pass:     ->(user, scene) { reset_decreased_stats(user, scene) },
        morning_sun:    ->(user, scene) { reset_decreased_stats(user, scene) },
        synthesis:      ->(user, scene) { reset_decreased_stats(user, scene) },
        moonlight:      ->(user, scene) { reset_decreased_stats(user, scene) },
        swallow:        ->(user, scene) { reset_decreased_stats(user, scene) },
        follow_me:      ->(user, scene) { reset_decreased_stats(user, scene) },
        helping_hand:   ->(user, scene) { reset_decreased_stats(user, scene) },
        tail_glow:      ->(user, scene) { reset_decreased_stats(user, scene) },
        slack_off:      ->(user, scene) { reset_decreased_stats(user, scene) },
        iron_defense:   ->(user, scene) { reset_decreased_stats(user, scene) },
        calm_mind:      ->(user, scene) { reset_decreased_stats(user, scene) },
        dragon_dance:   ->(user, scene) { reset_decreased_stats(user, scene) },
        roost:          ->(user, scene) { reset_decreased_stats(user, scene) },
        rock_polish:    ->(user, scene) { reset_decreased_stats(user, scene) },
        nasty_plot:     ->(user, scene) { reset_decreased_stats(user, scene) },
        heal_order:     ->(user, scene) { reset_decreased_stats(user, scene) },
        dark_void:      ->(user, scene) { reset_decreased_stats(user, scene) },
        autotomize:     ->(user, scene) { reset_decreased_stats(user, scene) },
        rage_powder:    ->(user, scene) { reset_decreased_stats(user, scene) },
        quiver_dance:   ->(user, scene) { reset_decreased_stats(user, scene) },
        coil:           ->(user, scene) { reset_decreased_stats(user, scene) },
        shell_smash:    ->(user, scene) { reset_decreased_stats(user, scene) },
        heal_pulse:     ->(user, scene) { reset_decreased_stats(user, scene) },
        shift_gear:     ->(user, scene) { reset_decreased_stats(user, scene) },
        cotton_guard:   ->(user, scene) { reset_decreased_stats(user, scene) },
        king_s_shield:  ->(user, scene) { reset_decreased_stats(user, scene) },
        shore_up:       ->(user, scene) { reset_decreased_stats(user, scene) },
        floral_healing: ->(user, scene) { reset_decreased_stats(user, scene) },

        # Focus attention
        destiny_bond: ->(user, scene) { focus_attention(user, scene) },
        grudge:       ->(user, scene) { focus_attention(user, scene) },

        # Boost crit ratio
        foresight:   ->(user, scene) { boost_crit_ratio(user, scene) },
        tailwind:    ->(user, scene) { boost_crit_ratio(user, scene) },
        acupressure: ->(user, scene) { boost_crit_ratio(user, scene) },
        heart_swap:  ->(user, scene) { boost_crit_ratio(user, scene) },

        # Full heal
        mist:         ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        teleport:     ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        haze:         ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        transform:    ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        conversion_2: ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        spite:        ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        belly_drum:   ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        heal_bell:    ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        psych_up:     ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        stockpile:    ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        refresh:      ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },
        aromatherapy: ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp) },

        # Other
        # mirror_move: ->(user, logic) { logic.stat_change_handler.stat_change_with_process(:atk, 2, user, user, self) }, -> Must call a Z-Move
        # me_first: ->(user, logic) { logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) }, -> Must call a Z-Move
        # copycat: ->(user, logic) { logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) }, -> Must call a Z-Move
        # sleep_talk: ->(user, _logic) { boost_crit_ratio(user) }, -> Must call a Z-Move
        curse:        ->(user, scene) { z_curse(user, scene) },
        memento:      ->(user, scene) { user.effects.add(Effects::ZHealNextAlly.new(scene.logic, user)) },
        parting_shot: ->(user, scene) { user.effects.add(Effects::ZHealNextAlly.new(scene.logic, user)) }
      }
      # rubocop:enable Layout/HashAlignment
      # rubocop:enable Naming/VariableNumber

      # Function that handles the Z-effect of increasing all user's stats by 1 stage
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def increase_all_stats(user, scene)
        scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self)
      end

      # Function that handles the Z-effect of resetting negative changes on the user's stats
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def reset_decreased_stats(user, scene)
        return if user.battle_stage.none? { |stage| stage < 0 }

        user.battle_stage.map! { |stage| stage < 0 ? 0 : stage }
        scene.display_message_and_wait(parse_text_with_pokemon(19, 195, user))
      end

      # Function that handles the Z-effect of focusing the attention on the user
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def focus_attention(user, scene)
        user.effects.add(Effects::CenterOfAttention.new(@logic, user, 1, self))
        scene.display_message_and_wait(parse_text_with_pokemon(19, 670, user))
      end

      # Function that handles the Z-effect of increasing the crit ratio of the user
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def boost_crit_ratio(user, scene)
        return if UNSTACKABLE_EFFECTS.any? { |e| target.effects.has?(e) }

        user.effects.add(Effects::FocusEnergy.new(@logic, user))
        scene.display_message_and_wait(parse_text_with_pokemon(19, 1047, user))
      end

      # Function that handles the Z-effect of Curse
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def z_curse(user, scene)
        if user.type_ghost?
          scene.logic.damage_handler.heal(user, user.max_hp)
        else
          scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self)
        end
      end

      # Internal procedure of the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      def proceed_internal(user, targets)
        return user.add_move_to_history(self, targets) unless (actual_targets = proceed_internal_precheck(user, targets))

        post_accuracy_check_effects(user, actual_targets)

        post_accuracy_check_move(user, actual_targets)

        play_animation(user, targets)

        deal_damage(user, actual_targets) &&
          effect_working?(user, actual_targets) &&
          deal_status(user, actual_targets) &&
          deal_stats(user, actual_targets) &&
          deal_z_effect(user, actual_targets) &&
          deal_effect(user, actual_targets)

        user.add_move_to_history(self, actual_targets)
        user.add_successful_move_to_history(self, actual_targets)
        @scene.visual.set_info_state(:move_animation)
        @scene.visual.wait_for_animation
      end

      # Tell if the move accuracy is bypassed
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @return [Boolean]
      def bypass_accuracy?(user, targets)
        return true if @is_z

        return super(user, targets)
      end

      # Function that deals the Z-effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_z_effect(user, actual_targets)
        return true unless @is_z
        return true unless status? && Z_STATUS_MOVES_EFFECTS.key?(db_symbol)

        Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene)
      end
    end

    prepend MoveZMovePlugin
  end

  module Effects
    # Healing Wish Effect
    class ZHealNextAlly < PokemonTiedEffectBase
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :z_heal_next_ally
      end

      # Function called when a Pokemon has actually switched with another one
      # @param handler [Battle::Logic::SwitchHandler]
      # @param who [PFM::PokemonBattler] Pokemon that is switched out
      # @param with [PFM::PokemonBattler] Pokemon that is switched in
      def on_switch_event(handler, who, with)
        handler.logic.damage_handler.heal(with, with.max_hp)
      end
    end
  end
end
