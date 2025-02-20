module Battle
  class Logic
    # Handler responsive of answering properly item changes requests
    class ItemChangeHandler < ChangeHandlerBase
      PROTECTED_ITEMS += %i[normalium_z fightinium_z flyinium_z poisonium_z groundium_z rockium_z buginium_z
                            ghostium_z steelium_z firium_z waterium_z grassium_z electrium_z psychium_z
                            icium_z dragonium_z darkinium_z fairium_z aloraichium_z decidium_z eevium_z
                            incinium_z kommonium_z lunalium_z lycanium_z marshadium_z mewnium_z mimikium_z
                            pikashunium_z primarium_z snorlium_z solganium_z tapunium_z ultranecrozium_z]
    end
  end
end
