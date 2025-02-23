module Battle
  class Logic
    class ZMoves
      # List of tools that allow Z-Moves
      Z_MOVES_TOOLS = %i[z_ring z_power_ring]

      # List of basic Z-crystals
      TYPE_Z_CRYSTALS = {
        normalium_z: { type: :normal, physical: :breakneck_blitz, special: :breakneck_blitz2 },
        fightinium_z: { type: :fighting, physical: :all_out_pummeling, special: :all_out_pummeling2 },
        flyinium_z: { type: :flying, physical: :supersonic_strike, special: :supersonic_strike2 },
        poisonium_z: { type: :poison, physical: :acid_downpour, special: :acid_downpour2 },
        groundium_z: { type: :ground, physical: :tectonic_rage, special: :tectonic_rage2 },
        rockium_z: { type: :rock, physical: :continental_crush, special: :continental_crush2 },
        buginium_z: { type: :bug, physical: :savage_spin_out, special: :savage_spin_out2 },
        ghostium_z: { type: :ghost, physical: :never_ending_nightmare, special: :never_ending_nightmare2 },
        steelium_z: { type: :steel, physical: :corkscrew_crash, special: :corkscrew_crash2 },
        firium_z: { type: :fire, physical: :inferno_overdrive, special: :inferno_overdrive2 },
        waterium_z: { type: :water, physical: :hydro_vortex, special: :hydro_vortex2 },
        grassium_z: { type: :grass, physical: :bloom_doom, special: :bloom_doom2 },
        electrium_z: { type: :electric, physical: :gigavolt_havoc, special: :gigavolt_havoc2 },
        psychium_z: { type: :psychic, physical: :shattered_psyche, special: :shattered_psyche2 },
        icium_z: { type: :ice, physical: :subzero_slammer, special: :subzero_slammer2 },
        dragonium_z: { type: :dragon, physical: :devastating_drake, special: :devastating_drake2 },
        darkinium_z: { type: :dark, physical: :black_hole_eclipse, special: :black_hole_eclipse2 },
        fairium_z: { type: :fairy, physical: :twinkle_tackle, special: :twinkle_tackle2 }
      }

      # List of signature Z-crystals
      SIGNATURE_Z_CRYSTALS = {
        aloraichium_z: [{ specie: :raichu, forms: [1], base_move: :thunderbolt, zmove: :stoked_sparksurfer, be_method: :s_basic }],
        decidium_z: [{ specie: :decidueye, forms: [0], base_move: :spirit_shackle, zmove: :sinister_arrow_raid, be_method: :s_basic }],
        eevium_z: [{ specie: :eevee, forms: [0], base_move: :last_resort, zmove: :extreme_evoboost, be_method: :s_self_stat }],
        incinium_z: [{ specie: :incineroar, forms: [0], base_move: :darkest_lariat, zmove: :malicious_moonsault, be_method: :s_stomp }],
        kommonium_z: [{ specie: :kommo_o, forms: [0], base_move: :clanging_scales, zmove: :clangorous_soulblaze, be_method: :s_self_stat }],
        lunalium_z: [
          { specie: :lunala, forms: [0], base_move: :moongeist_beam, zmove: :menacing_moonraze_maelstrom, be_method: :s_basic },
          { specie: :necrozma, forms: [2], base_move: :moongeist_beam, zmove: :menacing_moonraze_maelstrom, be_method: :s_basic }
        ],
        lycanium_z: [{ specie: :lycanroc, forms: [0, 1, 2], base_move: :stone_edge, zmove: :splintered_stormshards, be_method: :s_ice_spinner }],
        marshadium_z: [{ specie: :marshadow, forms: [0], base_move: :spectral_thief, zmove: :soul_stealing_7_star_strike, be_method: :s_basic }],
        mewnium_z: [{ specie: :mew, forms: [0], base_move: :psychic, zmove: :genesis_supernova, be_method: :s_genesis_supernova }],
        mimikium_z: [{ specie: :mimikyu, forms: [0], base_move: :play_rough, zmove: :let_s_snuggle_forever, be_method: :s_basic }],
        pikanium_z: [{ specie: :pikachu, forms: [0], base_move: :volt_tackle, zmove: :catastropika, be_method: :s_basic }],
        pikashunium_z: [{ specie: :pikachu, forms: [8..14], base_move: :thunderbolt, zmove: :s10_000_000_volt_thunderbolt, be_method: :s_basic }],
        primarium_z: [{ specie: :primarina, forms: [0], base_move: :sparkling_aria, zmove: :oceanic_operetta, be_method: :s_basic }],
        snorlium_z: [{ specie: :snorlax, forms: [0], base_move: :giga_impact, zmove: :pulverizing_pancake, be_method: :s_basic }],
        solganium_z: [
          { specie: :solgaleo, forms: [0], base_move: :sunsteel_strike, zmove: :searing_sunraze_smash, be_method: :s_basic },
          { specie: :necrozma, forms: [1], base_move: :moongeist_beam, zmove: :searing_sunraze_smash, be_method: :s_basic }
        ],
        tapunium_z: [
          { specie: :tapu_koko, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola },
          { specie: :tapu_lele, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola },
          { specie: :tapu_bulu, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola },
          { specie: :tapu_fini, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola }
        ],
        ultranecrozium_z: [{ specie: :raichu, forms: [0], base_move: :photon_geyser, zmove: :light_that_burns_the_sky, be_method: :s_photon_geyser }]
      }
    end

    class ItemChangeHandler < ChangeHandlerBase
      module ItemChangeHandlerZMovePlugin
        # List of item that cannot be manipulated during battle (Knock off, Trick, etc...)
        PROTECTED_ITEMS.concat(%i[normalium_z fightinium_z flyinium_z poisonium_z groundium_z rockium_z buginium_z
                                  ghostium_z steelium_z firium_z waterium_z grassium_z electrium_z psychium_z
                                  icium_z dragonium_z darkinium_z fairium_z aloraichium_z decidium_z eevium_z
                                  incinium_z kommonium_z lunalium_z lycanium_z marshadium_z mewnium_z mimikium_z
                                  pikanium_z pikashunium_z primarium_z snorlium_z solganium_z tapunium_z ultranecrozium_z])
      end

      prepend ItemChangeHandlerZMovePlugin
    end
  end

  class Move
    module MoveZMovePlugin
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
        mist:         ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        teleport:     ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        haze:         ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        transform:    ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        conversion_2: ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        spite:        ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        belly_drum:   ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        heal_bell:    ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        psych_up:     ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        stockpile:    ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        refresh:      ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },
        aromatherapy: ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) },

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
    end

    prepend MoveZMovePlugin
  end
end

module PFM
  class Pokemon
    # List of Z-Crystals
    Z_CRYSTALS = %i[normalium_z fightinium_z flyinium_z poisonium_z groundium_z rockium_z buginium_z
                    ghostium_z steelium_z firium_z waterium_z grassium_z electrium_z psychium_z
                    icium_z dragonium_z darkinium_z fairium_z aloraichium_z decidium_z eevium_z
                    incinium_z kommonium_z lunalium_z lycanium_z marshadium_z mewnium_z mimikium_z
                    pikanium_z pikashunium_z primarium_z snorlium_z solganium_z tapunium_z ultranecrozium_z]

    # List of Z_Crystals that can change Arceus's form
    ArceusZCrystalItem = %i[normalium_z firium_z waterium_z electrium_z grassium_z
                            icium_z fightinium_z poisonium_z groundium_z flyinium_z
                            psychium_z buginium_z rockium_z ghostium_z dragonium_z
                            steelium_z darkinium_z fairium_z]
  end
end

module Util
  module GiveTakeItem
    # List of Z crystals IDs associations, key is the big crystal, value is the held crystal
    Z_CRYSTALS_IDS = {
      807 => 776, # Normalium Z
      808 => 777, # Firium Z
      809 => 778, # Waterium Z
      810 => 779, # Electrium Z
      811 => 780, # Grassium Z
      812 => 781, # Icium Z
      813 => 782, # Fightinium Z
      814 => 783, # Poisonium Z
      815 => 784, # Groundium Z
      816 => 785, # Flyinium Z
      817 => 786, # Psychium Z
      818 => 787, # Buginium Z
      819 => 788, # Rockium Z
      820 => 789, # Ghostium Z
      821 => 790, # Dragonium Z
      822 => 791, # Darkinium Z
      823 => 792, # Steelium Z
      824 => 793, # Fairium Z
      825 => 794, # Pikanium Z
      826 => 798, # Decidium Z
      827 => 799, # Incinium Z
      828 => 800, # Primarium Z
      829 => 801, # Tapunium Z
      830 => 802, # Marshadium Z
      831 => 803, # Aloraichium Z
      832 => 804, # Snorlium Z
      833 => 805, # Eevium Z
      834 => 806, # Mewnium Z
      836 => 835, # Pikashunium Z
      1118 => 1112, # Solganium Z
      1119 => 1113, # Lunalium Z
      1120 => 1114, # Ultranecrozium Z
      1121 => 1115, # Mimikium Z
      1122 => 1116, # Lycanium Z
      1123 => 1117 # Kommonium Z
    }
  end
end
