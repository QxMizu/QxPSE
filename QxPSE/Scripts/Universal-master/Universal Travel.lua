name = "Universal Traveler"
author = "Crazy3001"
description = "Press Start."


				--#################################################--
				-------------------CONFIGURATION-------------------
				--#################################################--
--Favorites:

--KANTO
--Pokecenter Celadon      --Pokecenter Lavender     --Pokecenter Pewter                 --Safari Entrance
--Pokecenter Cerulean     --Pokecenter Saffron      --Pokemon League Reception Gate     --Power Plant
--Pokecenter Cinnabar     --Pokecenter Vermilion    --Mt. Silver Pokecenter             --Indigo Plateau Center
--Pokecenter Fuchsia      --Pokecenter Viridian     --Seafoam B4F
--

--JOHTO
--Pokecenter Azalea             --Pokecenter Ecruteak     --Pokecenter Violet City     --Ruins Of Alph
--Pokecenter Blackthorn         --Pokecenter Goldenrod    --Dragons Den                --Ilex Forest
--Pokecenter Cherrygrove City   --Pokecenter Mahogany     --Johto Safari Zone Lobby    
--Pokecenter Cianwood           --Olivine Pokecenter           
--

--HOENN
--Pokecenter Dewford Town       --Pokecenter Lavaridge Town    --Pokecenter Oldale Town       --Pokecenter Slateport
--Pokecenter Ever Grande City   --Pokecenter Lilycove City     --Pokecenter Pacifidlog Town   --Pokecenter Sootopolis City
--Pokecenter Fallarbor Town      --Pokecenter Mauville City     --Pokecenter Petalburg City    --Pokecenter Verdanturf
--Pokecenter Fortree City       --Pokecenter Mossdeep City     --Pokecenter Rustboro City     --Pokemon League Hoenn
--

local location = "Love Island"

local catchNotCaught = 	false --set true if you want to catch pokemon not listed as caught in your pokedex

local fight = false  --set true if you want to fight wild encounters on the way. false will run.

local goToNearestPokecenter = 	false  --set true to use the nearest pokecenter

local buyItem = false  --set true to use nearest pokemart that has the item below
local item = "" -- put the item you want to buy here
local amount = 1 -- put the amount of the item you want here



				--#################################################--
				----------------END OF CONFIGURATION-----------------
				--#################################################--


				--#################################################--
				-------------------START OF SCRIPT-------------------
				--#################################################--


local pf = require "Pathfinder/MoveToApp"
local map = nil

function onStart()
    shinyCounter = 0
    catchCounter = 0
    wildCounter = 0
	if goToNearestPokecenter == true then
		log("Travelling to " .. getMapName(goToNearestPokecenter) .. ".")
	else
		log("Travelling to " .. location .. ".")
	end
end

function onPause()
	log("***********************************PAUSED************************************")
end

function onResume()
	log("***********************************RESUMED***********************************")
 	if goToNearestPokecenter == true then
		log("Travelling to " .. getMapName(goToNearestPokecenter) .. ".")
	else
		log("Travelling to " .. location .. ".")
	end
end

function onBattleMessage(wild)
    if stringContains(wild, "A Wild SHINY ") then
       shinyCounter = shinyCounter + 1
       wildCounter = wildCounter + 1
       log("Info | Shinies Encountered: " .. shinyCounter)
       log("Info | Pokemon Caught: " .. catchCounter)
       log("Info | Pokemon Encountered: " .. wildCounter)
    elseif stringContains(wild, "Success! You caught ") then
       catchCounter = catchCounter + 1
       log("Info | Shinies Encountered: " .. shinyCounter)
       log("Info | Pokemon Caught: " .. catchCounter)
       log("Info | Pokemon Encountered: " .. wildCounter)
    elseif stringContains(wild, "A Wild ") then
       wildCounter = wildCounter + 1
       log("Info | Shinies Encountered: " .. shinyCounter)
       log("Info | Pokemon Caught: " .. catchCounter)
       log("Info | Pokemon Encountered: " .. wildCounter)
	elseif message == "You failed to run away!" then
        failedRun = true
	elseif message == "You can not switch this Pokemon!" then
		canNotSwitch = true
    end
end

function onPathAction()
local map = getMapName()
canNotSwitch = false
failedRun = false

	if goToNearestPokecenter == true then
		pf.useNearestPokecenter(map)
		if getMapName(goToNearestPokecenter) == getMapName() then
		end
	elseif buyItem then
		if not pf.useNearestPokemart(map, item, amount) then
			fatal("Finished Buying Item.")
		end
	else
		pf.moveTo(map, location)
		if getMapName() == location then
		end
	end
end

function onBattleAction()
	if isWildBattle() and isOpponentShiny() or (catchNotCaught and not isAlreadyCaught()) then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if isWildBattle() then 
		if isPokemonUsable(getActivePokemonNumber()) then
			if fight then
				return attack() or sendUsablePokemon() or run()
			else
				return run()
			end
		else
			return run() or sendUsablePokemon()
		end
	elseif canNotSwitch then
		canNotSwitch = false
		return attack() or run()
	else
		if failedRun then
			failedRun = false
			return sendUsablePokemon() or attack()
		else 
			return run() or sendUsablePokemon()
		end
	end
	return run() or sendUsablePokemon()
end
