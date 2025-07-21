extends Node

# random encounters
var rand_chance = 10
const BASE_RAND_ENCOUNTER_CHANCE = 10 # Out of 1000
const ADD_CHANCE = 5

# Disasters
var d_plague: RandomDisaster = load("res://scripts/resources/random_encounters/d_plague.tres")

# Fights
var f_goblin: RandomFight = load("res://scripts/resources/random_encounters/f_goblin.tres")

# Merchant/Trade
var t_merchant: RandomTrade = load("res://scripts/resources/random_encounters/t_wandering_merchant.tres")

# Map/Investigation
var m_shrine: RandomMap = load("res://scripts/resources/random_encounters/m_shrine.tres")

var listRandEnc = [d_plague, f_goblin, t_merchant, m_shrine]

func randomEncounterTick():
	var rand = RandomNumberGenerator.new()
	
	if (rand.randi_range(1,1000)) <= rand_chance:
		var encounter = rand.randi_range(0, listRandEnc.size()-1)
		print(listRandEnc[encounter].encounterName)
		listRandEnc.remove_at(encounter)
		rand_chance = BASE_RAND_ENCOUNTER_CHANCE
	else:
		print(rand_chance)
		rand_chance += ADD_CHANCE
