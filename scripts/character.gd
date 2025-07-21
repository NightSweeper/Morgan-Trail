class_name CharacterBase
extends Resource

@export var char_name: String = ""

# Character/Adventure Stats
# Mod, Prof, Adv
@export var stats: Dictionary = {
	"Strength" : [0,0,0],
	"Dexterity" : [0,0,0],
	"Constitution" : [0,0,0],
	"Intelligence" : [0,0,0],
	"Wisdom" : [0,0,0],
	"Charisma" : [0,0,0],
	"Initiative" : [0,0,0]
}
## [Max, Current]
@export var spell_slots := {
	"1st Level" : [0,0],
	"2nd Level" : [0,0]
}
@export var prof_bonus = Global.PROF_BONUS_LV1
@export var prof_weapons = {
	"Shortsword" : 0,
	"Longsword" : 0,
	"Mace" : 0,
	"Shortbow" : 0,
	"Longbow" : 0,
	"Greataxe" : 0,
	"Battleaxe" : 0
	
}

@export var level: int = 0
@export var characterClass: classBase
@export var status: int = 0


var health := 0
var health_cur := 0
@export var armor_class := 0
@export var mainHand: ItemBase
@export var armor: ItemBase
@export var speed : int
var usedMovement : int
var hasAttacked: bool = false
var usedReaction: bool = false
var isenemy = false

@export_category("Boons and Flaws")
@export var boons = {
	"Tough" : false, # +1 to AC and Con
	"Observant" : false, # + PB to initative rolls
	"Silver Tongue" : false, # Adv. or +PB extra to Charisma check
	"Lucky" : false, # +1 to every stat
	"Light Footed" : false,  # +PB extra to DEX
	"Athletic" : false # Tired less (Exhaustion not yet implemented) maybe +PB to Con
}

@export var flaws = {
	"Pot Bellied" : false, # 3 hunger instead
	"Daydreamer" : false, # -1 initative 
	"Out of Shape" : false, # -1 to Con and maybe exhaustion more
	"Sickly" : false, # Dis on Diseases checks and -1 to Con
	"Illiterate" : false, # -1 to Wis and Int 
	"Flat Footed" : false # -1 to Dex
}

@export_category("Diseases")
@export var diseases = {
	"Plague" : false # -2 to Str and -2 to Dex, 
}

@export_category("Spells!")
var spell_save_dc := 0
var casting_ability := ""
var inCon := false
@export var cantrip := {
	"Blade Ward" : false,
	"Acid Splash" : false,
	"Chill Touch" : false,
	"Fire Bolt" : false,
	"Mind Sliver" : false,
	"Poison Spray" : false,
	"Primal Savagery" : false
}

@export var spells_1 := {
	"Bless" : false,
	"Burning Hands" : false,
	"Chromatic Orb" : false,
	"Cure Wounds" : false
}

var conditions = {
	"Blade Ward" : false,
	"Bless" : false
}

func setUp():
	calHealth()
	updateStats()
	calAC()
	resetMovement()

func calHealth():
	# (hit die + constitution) * level
	health = stats["Constitution"][0] + characterClass.hitDice
	# Takes average roll of hitdie plus con mod * the level
	health += (stats["Constitution"][0] + (characterClass.hitDice / 2) + 1) * (level-1)
	health_cur = health
	
func calAC():
	
	armor_class = 10 + stats["Dexterity"][0]

func updateStats():
	
	stats["Strength"][0] += prof_bonus * stats["Strength"][1]
	stats["Dexterity"][0] += prof_bonus * stats["Dexterity"][1]
	stats["Constitution"][0] += prof_bonus * stats["Constitution"][1]
	stats["Intelligence"][0] += prof_bonus * stats["Intelligence"][1]
	stats["Wisdom"][0] += prof_bonus * stats["Wisdom"][1]
	stats["Charisma"][0] += prof_bonus * stats["Charisma"][1]
	stats["Initiative"][0] = 10 + stats["Dexterity"][0]
	
	if characterClass.className == "Wizard":
		casting_ability = "Intelligence"
		spell_save_dc = 8 + stats["Intelligence"][0] + prof_bonus
	if characterClass.className == "Druid":
		casting_ability = "Wisdom"
		spell_save_dc = 8 + stats["Wisdom"][0] + prof_bonus
	else:
		print("None")
	
func resetMovement():
	usedMovement = speed
	hasAttacked = false

func attackRoll():
	
	var roll = 0
	
	if stats["Strength"][0] > stats["Dexterity"][0] and mainHand.itemName == "Shortsword":
		roll = returnRoll("Strength")
	elif stats["Strength"][0] < stats["Dexterity"][0] and mainHand.itemName == "Shortsword":
		roll = returnRoll("Dexterity")
	else:
		roll = returnRoll("Strength")
	
	return roll

func magicRoll():
	
	var roll = 0
	
	if characterClass.className == "Wizard":
		casting_ability = "Intelligence"
	if characterClass.className == "Druid":
		casting_ability = "Wisdom"
	else:
		print("None")
	
	roll = returnRoll(casting_ability)
	
	return roll


func attackDamage():
	
	var raw_damage = Catalog.getDamageFromItem(mainHand)
	if stats["Strength"][0] > stats["Dexterity"][0] and mainHand.itemName == "Shortsword":
		raw_damage += stats["Strength"][0]
	elif stats["Strength"][0] < stats["Dexterity"][0] and mainHand.itemName == "Shortsword":
		raw_damage += stats["Dexterity"][0]
	else:
		raw_damage += stats["Strength"][0]
	
	return raw_damage

func skillCheck(dc: int, skill: String) -> bool:
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var diceroll = rand.randi_range(1,20) + stats[skill][0]
	
	if conditions["Bless"]:
		print("Thank god for bless")
		diceroll += rand.randi_range(1,4)

	
	if diceroll >= dc:
		return true # meets skill check
	
	return false # does not meet skill check

func returnRoll(skill: String):
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	print( stats[skill][0])
	var diceroll = rand.randi_range(1,20) + stats[skill][0]
	
	if conditions["Bless"]:
		print("Thank god for bless")
		diceroll += rand.randi_range(1,4)
	
	return diceroll

func getStatus():
	match status:
		1:
			return "Normal"
		2:
			return "Tired"
		3:
			return "Exhausted"
		4:
			return "Sick"
		_:
			return "Normal"
