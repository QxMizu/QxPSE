
name = "EV Trainer"
author = "QxMizu"

function onStart()

	dofile 'lib/system.lua'
	dofile 'config.lua'
	dofile 'lib/evMap.lua'

	log("EV Trainer | Version 1.0 Release")
	getStartLogs()

	if autoEvolve == "on" then
		if not isAutoEvolve() then
			enableAutoEvolve()
			log("EV Trainer | AutoEvolve enabled")
		else
			log("EV Trainer | AutoEvolve is already enabled")
		end
	end

	if autoEvolve == "off" then
		if isAutoEvolve then
			disableAutoEvolve()
			log("EV Trainer | AutoEvolve disabled")
		else
			log("EV Trainer | AutoEvolve is already disabled")
		end
	end

end

function onPause()
	log("EV Trainer | Paused")
end

function onResume()
	dofile 'config.lua'
	log("EV Trainer | Resumed - Config reloaded")
end

function onPathAction()
		
		if Hp_Training[1] then
			startTraining(Hp_Training, "HP", Hp)
		-- start Atk Training
		elseif not Hp_Training[1] and Spd_Training[1] then
			startTraining(Spd_Training, "SPD", Spd)
		-- Start Def Training
		elseif not Hp_Training[1] and not Spd_Training[1] and Def_Training[1] then
			startTraining(Def_Training, "DEF", Def)
		-- Start Spd Training
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and Atk_Training[1] then
			startTraining(Atk_Training, "ATK", Atk)
		-- Start SpAtk Training
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and not Atk_Training[1] and SpAtk_Training[1] then
			startTraining(SpAtk_Training, "SPATK", SpAtk)
		-- Start SpDef Training
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and not Atk_Training[1] and not SpAtk_Training[1] and SpDef_Training[1] then
			startTraining(SpDef_Training, "SPDEF", SpDef)
		-- Finished all Trainings
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and not Atk_Training[1] and not SpAtk_Training[1] and not SpDef_Training[1] then
			fatal("Ev Trainer | Training finished !")
			logout()
		end
		
		
end

function onBattleAction()
	
		-- start Hp Training
		if Hp_Training[1] then
			gainEv(Hp)
		-- start Atk Training
		elseif not Hp_Training[1] and Spd_Training[1] then
			gainEv(Spd)
		-- Start Def Training
		elseif not Hp_Training[1] and not Spd_Training[1] and Def_Training[1] then
			gainEv(Def)
		-- Start Spd Training
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and Atk_Training[1] then
			gainEv(Atk)
		-- Start SpAtk Training
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and not Atk_Training[1] and SpAtk_Training[1] then
			gainEv(SpAtk)
		-- Start SpDef Training
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and not Atk_Training[1] and not SpAtk_Training[1] and SpDef_Training[1] then
			gainEv(SpDef)
		-- Finished all Trainings
		elseif not Hp_Training[1] and not Spd_Training[1] and not Def_Training[1] and not Atk_Training[1] and not SpAtk_Training[1] and not SpDef_Training[1] then
			fatal("Ev Trainer | Started script with no or wrong configuration, please fix this !")
		end
	
end

function onBattleMessage(wild)
	if stringContains(wild, "You have won the battle.") then
		log("EV Trainer | "..getPokemonName(1).." HP    : "..getPokemonEffortValue(1, "HP"))
		log("EV Trainer | "..getPokemonName(1).." Atk   : "..getPokemonEffortValue(1, "ATK"))
		log("EV Trainer | "..getPokemonName(1).." Def   : "..getPokemonEffortValue(1, "DEF"))
		log("EV Trainer | "..getPokemonName(1).." Spd   : "..getPokemonEffortValue(1, "SPD"))
		log("EV Trainer | "..getPokemonName(1).." SpAtk : "..getPokemonEffortValue(1, "SPATK"))
		log("EV Trainer | "..getPokemonName(1).." SpDef : "..getPokemonEffortValue(1, "SPDEF"))
	end
end