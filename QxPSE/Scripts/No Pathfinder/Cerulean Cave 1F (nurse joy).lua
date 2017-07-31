function onPathAction()

    if isPokemonUsable(1) then

        if getMapName() == "Cerulean Cave 1F" then
            moveToRectangle(55, 13, 55, 14)
        end

    else

        if getMapName() == "Cerulean Cave 1F" then
            talkToNpcOnCell(55, 12)
        end
        
    end

end

function onBattleAction()
    if isWildBattle() and isOpponentShiny()  then
                if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
            return
            end
    end
    
    if getActivePokemonNumber() == 1 then
        return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
    else
        return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
    end
end