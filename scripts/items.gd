class_name ItemBase
extends Resource

@export var itemName := ""
@export var itemDesc := ""
@export var itemType := "" # Weapon, Adventure, Armor, Battle (?)
@export var equiped := false
@export var owner: CharacterBase
@export var itemCost: int = 0
