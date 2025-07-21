class_name MobBase
extends Resource

@export var mobName := ""
@export_enum("Humanoid", "Undead", "Monstrosity", "Beast") var mobType := 0

@export_category("Mob Stats")
@export var stats = {
	"Strength" : [0,0,0],
	"Dexterity" : [0,0,0],
	"Constitution" : [0,0,0],
	"Intelligence" : [0,0,0],
	"Wisdom" : [0,0,0],
	"Charisma" : [0,0,0],
	"Initiative" : [0,0,0]
}
@export var hp := 0
var hp_cur := hp
@export var armor_class := 0
@export var mainHand : ItemBase
@export var speed : int
var usedMovement : int
var hasAttacked : bool = false
var usedReaction: bool = false
var isenemy = true
@export var image : CompressedTexture2D


var conditions = {
	"Blade Ward" : false,
	"Bless" : false,
	"Mind Sliver" : false
}

func setUp() -> void:
	mainHand = mainHand.duplicate(true)
	resetMovement()
	setHealth()

func resetMovement():
	usedMovement = speed
	hasAttacked = false

func setHealth():
	hp_cur = hp


func attackRoll(char: CharacterBase):
	
	var roll = 0
	var subtract = 0
	var add = 0
	
	if char.conditions["Blade Ward"]:
		subtract = 4
	if stats["Strength"][0] > stats["Dexterity"][0] and mainHand.itemName == "Shortsword":
		roll = returnRoll("Strength", subtract)
	elif stats["Strength"][0] < stats["Dexterity"][0] and mainHand.itemName == "Shortsword":
		roll = returnRoll("Dexterity", subtract)
	else:
		roll = returnRoll("Strength", subtract)
		
	
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
	
	var diceroll = randi_range(1,20) + stats[skill][0]
	
	if diceroll >= dc:
		return true # meets skill check
	
	return false # does not meet skill check


func returnRoll(skill: String, subtract := 0, add := 0):
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var diceroll = randi_range(1,20) + stats[skill][0]
	
	
	if subtract != 0:
		diceroll -= randi_range(1, subtract)
	if add != 0:
		diceroll -= randi_range(1, subtract)
	
	return diceroll
