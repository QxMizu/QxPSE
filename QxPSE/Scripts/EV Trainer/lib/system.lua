local PathFinder = require "Pathfinder/Maps_Pathfind"

function onStart()
	PathFinder.DisableDigPath()
end

-- Return index from PokemonName
function getPokemonNameIndex(name)
	for i = 1, getTeamSize() do
		if getPokemonName(i) == name then
			return i
		end
	end
end

-- Return true/false if EV is maxed or not
function isEvDone(ev, EvTable)

	if EvTable[1][2] then
		if getPokemonEffortValue(1, ev) >= EvTable[1][2] then
			return true
		else
			return false
		end
	else
		if getPokemonEffortValue(1, ev) >= 252 then
			return true
		else
			return false
		end
	end
end

function isFullyTrained(index)
	if getPokemonEffortValue(index, "HP") + getPokemonEffortValue(index, "ATK") + getPokemonEffortValue(index, "DEF") + getPokemonEffortValue(index, "SPATK") + getPokemonEffortValue(index, "SPDEF") + getPokemonEffortValue(index, "SPD") == 510 then
		return true
	else
		return false
	end
end

function isOpponentCorrect(EvShort)
    for i = 1 , #EvShort[2] do
        if getOpponentName() == EvShort[2][i] then
            return true
        end
    end
    return false
end

function gainEv(EvShort)
	if getActivePokemonNumber() == 1 then
		if isOpponentCorrect(EvShort) then
			return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
		else
			return run() or sendUsablePokemon() or sendAnyPokemon()
		end
	else
		return run() or sendUsablePokemon() or sendAnyPokemon()
	end
end

function onLearningMove(moveName, pokemonIndex)
    local ForgetMoveName
    local ForgetMoveTP = 9999
    for moveId=1, 4, 1 do
        local MoveName = getPokemonMoveName(pokemonIndex, moveId)
        if MoveName == nil or MoveName == "cut" or MoveName == "surf" or MoveName == "rock smash" or MoveName == "rocksmash" then
        else
        local CalcMoveTP = math.modf((getPokemonMaxPowerPoints(pokemonIndex,moveId) * getPokemonMovePower(pokemonIndex,moveId))*(math.abs(getPokemonMoveAccuracy(pokemonIndex,moveId)) / 100))
            if CalcMoveTP < ForgetMoveTP then
                ForgetMoveTP = CalcMoveTP
                ForgetMoveName = MoveName
            end
        end
    end
    log("==== Learning new Move ====")
    log(" ")
    log("[ Learned -> ] ".. moveName)
    log("[ Forgot  -> ] ".. ForgetMoveName)
    log(" ")
    log("========================")
    return ForgetMoveName
end

function getHealed()
	if stringContains(getMapName(), "Pokecenter") then
		usePokecenter()
	else
		PathFinder.MoveToPC()
	end
end

function getLevelSpot(EvShort)
	if EvShort[3][1] == "Grass" then
		moveToGrass()
	elseif EvShort[3][1] == "Water" then
		moveToWater()
	else
		moveToRectangle(EvShort[3][1], EvShort[3][2], EvShort[3][3], EvShort[3][4])
	end
end

function startTraining(EvTable, EvName, EvShort)
	if isPokemonUsable(1) then
		if getPokemonName(1) ~= EvTable[1][1] then
			swapPokemonWithLeader(EvTable[1][1])
		elseif getPokemonName(1) == EvTable[1][1] and not isEvDone(EvName, EvTable) then
			if not isLastTenEvs(EvTable, EvName) then
			if hasTeamMachoBrace() or hasItem("Macho Brace") then
				if not hasMachoBrace() then
					if not hasItem("Macho Brace") then
						getItemFromTeam("Macho Brace")
						log("EV Trainer | Receive Macho Brace from Team")
					elseif hasItem("Macho Brace") then
						giveItemToPokemon("Macho Brace", 1)
						log("EV Trainer | Macho Brace equiped")
					else
						log("error: wtf have i done")
					end
				else
					if getMapName() ~= EvShort[1] then
						PathFinder.MoveTo(EvShort[1])
					else
						getLevelSpot(EvShort)
					end
				end
			else
				log("EV Trainer | Macho Brace not found -> Continue without !")
				if getMapName() ~= EvShort[1] then
					PathFinder.MoveTo(EvShort[1])
				else
					getLevelSpot(EvShort)
					end
			end

			elseif isLastTenEvs(EvTable, EvName) and getPokemonHeldItem(1) == "Macho Brace" then
				log("EV Trainer | Less then 10 missing EV's -> Removed Macho Brace")
				takeItemFromPokemon(1)

			else
				if getMapName() ~= EvShort[1] then
					PathFinder.MoveTo(EvShort[1])
				else
					getLevelSpot(EvShort)
				end
			end



		elseif getPokemonName(1) == EvTable[1][1] and isEvDone(EvName, EvTable) then
			log("EV Trainer | "..getPokemonName(1).." finished "..EvName.."-Training ! [ "..getPokemonEffortValue(1, EvName).." / ".. EvTable[1][2].. " ]")
			table.remove(EvTable, 1)
		end
	else
		getHealed()
	end
end

function getStartLogs()
	if Hp_Training[1] then
		for i = 1, #Hp_Training do
			log("EV Trainer | HP Training -> "..Hp_Training[i][1])
		end
	end

	if Atk_Training[1] then
		for i = 1, #Atk_Training do
			log("EV Trainer | Atk Training -> "..Atk_Training[i][1])
		end
	end

	if Def_Training[1] then
		for i = 1, #Def_Training do
			log("EV Trainer | Def Training -> "..Def_Training[i][1])
		end
	end

	if Spd_Training[1] then
		for i = 1, #Spd_Training  do
			log("EV Trainer | Spd Training -> "..Spd_Training[i][1])
		end
	end

	if SpAtk_Training[1] then
		for i = 1, #SpAtk_Training do
			log("EV Trainer | SpAtk Training -> "..SpAtk_Training[i][1])
		end
	end

	if SpDef_Training[1] then
		for i = 1, #SpDef_Training do
			log("EV Trainer | SpDef Training -> "..SpDef_Training[i][1])
		end
	end
end

function hasMachoBrace()
	if getPokemonHeldItem(1) == "Macho Brace" then
		return true
	else
		log("First pokemon doesn't have macho brace")
		return false
	end
end

function hasTeamMachoBrace()
	for i = 1, getTeamSize() do
		if getPokemonHeldItem(i) == "Macho Brace" then
			return true
		end
	end
	return false
end


function getItemFromTeam(itemName)
	if getPokemonHeldItem(1) ~= itemName then
		for i = 1, getTeamSize() do
			if getPokemonHeldItem(i) == itemName then
				takeItemFromPokemon(i)
			end
		end
	end
end


function isLastTenEvs(EvTable, ev)
	if getPokemonEffortValue(1, ev) >= ( EvTable[1][2] - 10 ) then
		return true
	else
		return false
	end
end
