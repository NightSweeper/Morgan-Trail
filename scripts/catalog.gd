extends Node

var rand = RandomNumberGenerator.new()

# Martial Weapon
var shortsword = load("res://scripts/resources/items/shortsword.tres")
var longsword = load("res://scripts/resources/items/longsword.tres")
var battleaxe = load("res://scripts/resources/items/battleaxe.tres")
var greataxe = load("res://scripts/resources/items/greataxe.tres")
var mace = load("res://scripts/resources/items/Mace.tres")
var shortbow = load("res://scripts/resources/items/shortbow.tres")
var longbow = load("res://scripts/resources/items/longbow.tres")

# Adventure
var shovel = load("res://scripts/resources/items/shovel.tres")
var torch = load("res://scripts/resources/items/torch.tres")

# Armor
var leather_armor = load("res://scripts/resources/items/leather_armor.tres")
var chain_mail = load("res://scripts/resources/items/chain_mail.tres")
var plate_armor = load("res://scripts/resources/items/plate_armor.tres")

# Food
var ration = load("res://scripts/resources/items/ration.tres")
# So currenty 48 Gold per 100 miles at 4 pounds per character and 10 miles per day

# Martial
const SHORTSWORD_DAMAGE = 6
const MACE_DAMAGE = 6
const LONGSWORD_DAMAGE = 10
const BATTLEAXE_DAMAGE = 8
const GREATAXE_DAMAGE = 12

# Ranged
const SHORTBOW_DAMAGE = 6
const LONGBOW_DAMAGE = 8

# ARMOR
const LEATHER_ARMOR = 12
const CHAIN_MAIL = 16
const PLATE_ARMOR = 18

#Dict of Items
var Items := {
	"Shortsword": shortsword,
	"Longsword" : longsword,
	"Battleaxe" : battleaxe,
	"Greataxe" : greataxe,
	"Mace" : mace,
	"Shortbow" : shortbow,
	"Longbow" : longbow,
	"Shovel" : shovel,
	"Torch" : torch,
	"Leather Armor": leather_armor,
	"Chain Mail" : chain_mail,
	"Plate Armor" : plate_armor,
	"Ration" : ration
}

func getDamageFromItem(item: ItemBase) -> int:
	rand.randomize()
	var weapon = item.itemName 
	var damage = 0
	if (item.itemType != "Weapon"):
		return 0

	if weapon == "Shortsword":
		damage = rand.randi_range(1,SHORTSWORD_DAMAGE)
		return damage
	if weapon == "Longsword":
		damage = rand.randi_range(1,LONGSWORD_DAMAGE)
		return damage
	if weapon == "Mace":
		damage = rand.randi_range(1,MACE_DAMAGE)
		return damage
	if weapon == "Battleaxe":
		damage = rand.randi_range(1,BATTLEAXE_DAMAGE)
		return damage
	if weapon == "Greataxe":
		damage = rand.randi_range(1,GREATAXE_DAMAGE)
		return damage
	if weapon == "Shortbow":
		damage = rand.randi_range(1,SHORTBOW_DAMAGE)
		return damage
	if weapon == "Longbow":
		damage = rand.randi_range(1,LONGBOW_DAMAGE)
		return damage
	
	return 0
	

func getDamageFromItemRange(item: ItemBase) -> int:
	var weapon := item.itemName 
	var damage := 0
	if (item.itemType != "Weapon"):
		return 0
	
	if weapon == "Shortsword":
		return SHORTSWORD_DAMAGE
	if weapon == "Longsword":
		return LONGSWORD_DAMAGE
	if weapon == "Mace":
		return MACE_DAMAGE
	if weapon == "Battleaxe":
		return BATTLEAXE_DAMAGE
	if weapon == "Greataxe":
		return GREATAXE_DAMAGE
	if weapon == "Shortbow":
		return SHORTBOW_DAMAGE
	if weapon == "Longbow":
		return LONGBOW_DAMAGE
	
	return 0
	

func getACfromArmor(item: ItemBase, character: CharacterBase):
	
	var armor := item.itemName
	var ac := 0
	
	if (item.itemType != "Armor"):
		return 0
	
	if armor == "Leather Armor":
		return LEATHER_ARMOR + character.stats["Dexterity"][0]
	if armor == "Chain Mail":
		var mod = 0
		# MAX 2 Dex
		if character.stats["Dexterity"][0] > 2:
			mod = 2
		else:
			mod = character.stats["Dexterity"][0]
		return CHAIN_MAIL + mod
	if armor == "Plate Armor":
		return PLATE_ARMOR
