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
        **%i[
          tail_whip
          leer
          meditate
          screech
          sharpen
          will_o_wisp
          taunt
          odor_sleuth
          howl
          bulk_up
          power_trick
          hone_claws
          work_up
          rototiller
          topsy_turvy
          laser_focus
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:atk, 1, user, scene) }
        end,
        splash: ->(user, scene) { apply_stat_change(:atk, 3, user, scene) },

        # Defense
        **%i[
          growl
          roar
          poison_powder
          toxic
          harden
          withdraw
          reflect
          poison_gas
          spider_web
          spikes
          charm
          pain_split
          torment
          feather_dance
          tickle
          block
          toxic_spikes
          aqua_ring
          stealth_rock
          defend_order
          wide_guard
          quick_guard
          mat_block
          noble_roar
          flower_shield
          grassy_terrain
          fairy_lock
          play_nice
          spiky_shield
          venom_drench
          baby_doll_eyes
          baneful_bunker
          strength_sap
          tearful_look
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:dfe, 1, user, scene) }
        end,

        # Special Attack
        **%i[
          growth
          confuse_ray
          mind_reader
          nightmare
          sweet_kiss
          teeter_dance
          fake_tears
          metal_sound
          gravity
          miracle_eye
          embargo
          telekinesis
          soak
          simple_beam
          reflect_type
          ion_deluge
          electrify
          gear_up
          psychic_terrain
          instruct
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:ats, 1, user, scene) }
        end,

        psycho_shift: ->(user, scene) { apply_stat_change(:ats, 2, user, scene) },
        heal_block: ->(user, scene) { apply_stat_change(:ats, 2, user, scene) },

        # Special Defense
        **%i[
          whirlwind
          stun_spore
          thunder_wave
          light_screen
          glare
          mean_look
          flatter
          charge
          wish
          ingrain
          mud_sport
          cosmic_power
          water_sport
          wonder_room
          magic_room
          entrainment
          crafty_shield
          misty_terrain
          confide
          eerie_impulse
          magnetic_flux
          spotlight
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:dfs, 1, user, scene) }
        end,

        **%i[
          magic_coat
          imprison
          captivate
          aromatic_mist
          powder
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:dfs, 2, user, scene) }
        end,

        # Speed
        **%i[
          sing
          supersonic
          sleep_powder
          string_shot
          hypnosis
          lovely_kiss
          scary_face
          lock_on
          sandstorm
          safeguard
          encore
          rain_dance
          sunny_dance
          hail
          role_play
          yawn
          skill_swap
          grass_whistle
          gastro_acid
          power_swap
          guard_swap
          worry_seed
          guard_split
          power_split
          after_you
          quash
          sticky_web
          electric_terrai
          toxic_thread
          speed_swap
          aurora_veil
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:spd, 1, user, scene) }
        end,

        **%i[
          trick
          recycle
          snatch
          switcheroo
          ally_switch
          bestow
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:spd, 2, user, scene) }
        end,

        # Accuracy
        **%i[
          mimic
          defense_curl
          focus_energy
          sweet_scent
          defog
          trick_room
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:acc, 1, user, scene) }
        end,

        # Evasion
        **%i[
          sand_attack
          smokescreen
          kinesis
          flash
          detect
          camouflage
          lucky_chant
          magnet_rise
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { apply_stat_change(:eva, 1, user, scene) }
        end,

        # All basic stats
        **%i[
          conversion
          sketch
          trick_or_treat
          forest_s_curse
          geomancy
          happy_hour
          celebrate
          hold_hands
          purify
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { increase_all_stats(user, scene) }
        end,

        # Reset decreased stats
        **%i[
          swords_dance
          disable
          leech_seed
          agility
          double_team
          recover
          minimize
          barrier
          amnesia
          soft_boiled
          spore
          acid_armor
          rest
          substitute
          cotton_spore
          protect
          perish_song
          endure
          swagger
          milk_drink
          attract
          baton_pass
          morning_sun
          synthesis
          moonlight
          swallow
          follow_me
          helping_hand
          tail_glow
          slack_off
          iron_defense
          calm_mind
          dragon_dance
          roost
          rock_polish
          nasty_plot
          heal_order
          dark_void
          autotomize
          rage_powder
          quiver_dance
          coil
          shell_smash
          heal_pulse
          shift_gear
          cotton_guard
          king_s_shield
          shore_up
          floral_healing
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { reset_decreased_stats(user, scene) }
        end,

        # Focus attention
        destiny_bond: ->(user, scene) { focus_attention(user, scene) },
        grudge:       ->(user, scene) { focus_attention(user, scene) },

        # Boost crit ratio
        **%i[
          foresight
          tailwind
          acupressure
          heart_swap
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { boost_crit_ratio(user, scene) }
        end,

        # Full heal
        **%i[
          mist
          teleport
          haze
          transform
          conversion_2
          spite
          belly_drum
          heal_bell
          psych_up
          stockpile
          refresh
          aromatherapy
        ].each_with_object({}) do |action, hash|
          hash[action] = ->(user, scene) { scene.logic.damage_handler.heal(user, user.max_hp, false) }
        end,

        # Other
        mirror_move: ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:atk, 2, user, user, self) },
        # me_first: ->(user, logic) { logic.stat_change_handler.stat_change_with_process(:spd, 2, user, user, self) }, -> Must call a Z-Move
        copycat:      ->(user, scene) { scene.logic.stat_change_handler.stat_change_with_process(:acc, 1, user, user, self) },
        sleep_talk:   ->(user, scene) { boost_crit_ratio(user, scene) },
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
