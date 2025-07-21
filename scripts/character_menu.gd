extends Control

@export var char1: CharacterBase
@export var char2: CharacterBase
@export var char3: CharacterBase
@export var char4: CharacterBase

@export var char_show: CharacterBase
@export var inv_list: ItemList
var item: ItemBase = null

func _process(delta: float) -> void:
	$ColorRect/ColorRect/AC.text = "AC: " + str(char_show.armor_class)
	$ColorRect/c_Name.text = char_show.char_name
	$ColorRect/lvl_class.text = "LVL " + str(char_show.level) + " " + char_show.characterClass.getClassName()
	$ColorRect/ColorRect/STR.text = "STR: " + str(char_show.stats["Strength"][0])
	$ColorRect/ColorRect/DEX.text = "DEX: " + str(char_show.stats["Dexterity"][0])
	$ColorRect/ColorRect/CON.text = "CON: " + str(char_show.stats["Constitution"][0])
	$ColorRect/ColorRect/INT.text = "INT: " + str(char_show.stats["Intelligence"][0])
	$ColorRect/ColorRect/WIS.text = "WIS: " + str(char_show.stats["Wisdom"][0])
	$ColorRect/ColorRect/CHA.text = "CHA: " + str(char_show.stats["Charisma"][0])
	$ColorRect/ColorRect/PB.text = "PB: " + str(char_show.prof_bonus)
	$ColorRect/ColorRect/IN.text = "IN: " + str(char_show.stats["Initiative"][0])
	
	if (char_show.stats["Strength"][1] == 1):
		$ColorRect/ColorRect/STR/prof_bonus_str.show()
	else:
		$ColorRect/ColorRect/STR/prof_bonus_str.hide()
	
	if (char_show.stats["Dexterity"][1] == 1):
		$ColorRect/ColorRect/DEX/prof_bonus_dex.show()
	else:
		$ColorRect/ColorRect/DEX/prof_bonus_dex.hide()
	
	
	if (char_show.stats["Constitution"][1] == 1):
		$ColorRect/ColorRect/CON/prof_bonus_con.show()
	else:
		$ColorRect/ColorRect/CON/prof_bonus_con.hide()
	
	if (char_show.stats["Intelligence"][1] == 1):
		$ColorRect/ColorRect/INT/prof_bonus_int.show()
	else:
		$ColorRect/ColorRect/INT/prof_bonus_int.hide()
	
	if (char_show.stats["Wisdom"][1] == 1):
		$ColorRect/ColorRect/WIS/prof_bonus_wis.show()
	else:
		$ColorRect/ColorRect/WIS/prof_bonus_wis.hide()
	
	if (char_show.stats["Charisma"][1] == 1):
		$ColorRect/ColorRect/CHA/prof_bonus_cha.show()
	else:
		$ColorRect/ColorRect/CHA/prof_bonus_cha.hide()
	
	if Global.load_inv:
		print(Global.load_inv)
		Global.load_inv = false
		for i in Global.inv:
			print(i.itemName)
			if i.equiped:
				inv_list.add_item(i.itemName + " (equipped)")
			else:
				inv_list.add_item(i.itemName)
	if item != null:
		$ColorRect/ColorRect2/itemName.text = item.itemName
		if item.equiped:
			$ColorRect/ColorRect2/itemName.text += " (equipped)"
		if (item.itemType == "Weapon" or item.itemType == "Armor"):
			$ColorRect/ColorRect2/equip.show()
		else:
			$ColorRect/ColorRect2/equip.hide()
	
	if not char_show.mainHand == null:
		$ColorRect/ColorRect/Weapon/main_hand_name.text = char_show.mainHand.itemName
		$ColorRect/ColorRect/Weapon/damageRange.text = str(1 + char_show.stats["Constitution"][0]) + "-" + str(Catalog.getDamageFromItemRange(char_show.mainHand) + char_show.stats["Constitution"][0])
		$"ColorRect/ColorRect/Weapon/+hit".text = "+" + str(char_show.stats["Strength"][0] + (char_show.prof_weapons[char_show.mainHand.itemName] * char_show.prof_bonus))
	else:
		$ColorRect/ColorRect/Weapon/main_hand_name.text = "None"
		$ColorRect/ColorRect/Weapon/damageRange.text = "0-0"
		$"ColorRect/ColorRect/Weapon/+hit".text = "+0"
	if not char_show.armor == null:
		$ColorRect/ColorRect/Armor/armor_desc.text = char_show.armor.itemName
	else:
		$ColorRect/ColorRect/Armor/armor_desc.text = "None"

func _on_character_panel_1_pressed() -> void:
	char_show = char1


func _on_character_panel_2_pressed() -> void:
	char_show = char2


func _on_character_panel_3_pressed() -> void:
	char_show = char3


func _on_character_panel_4_pressed() -> void:
	char_show = char4


func _on_button_pressed() -> void:
	Global.inEquipMenu = false
	Global.run = true
	inv_list.clear()
	
func updateInv():
	inv_list.clear()
	for i in Global.inv:
			print(i.itemName)
			if i.equiped:
				inv_list.add_item(i.itemName + " (equipped)")
			else:
				inv_list.add_item(i.itemName)


func _on_inv_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	item = Global.inv[index]
	if item.equiped:
		$ColorRect/ColorRect2/equip.text = "Unequip"
	else:
		$ColorRect/ColorRect2/equip.text = "Equip"
func updateHandandArmor():
	
	if item.itemType == "Weapon" and item.equiped:
		item.owner.mainHand = null
		item.owner = null
		item.equiped = false
	elif item.itemType == "Armor" and item.equiped:
		item.owner.armor = null
		item.owner.calAC()
		item.owner = null
		item.equiped = false
	elif item.itemType == "Weapon" and item.equiped == false:
		if char_show.mainHand != null:
			char_show.mainHand.equiped = false
		char_show.mainHand = item
		item.owner = char_show
		$ColorRect/ColorRect/Weapon/main_hand_name.text = char_show.mainHand.itemName
		$ColorRect/ColorRect/Weapon/damageRange.text = str(1 + char_show.stats["Constitution"][0]) + "-" + str(Catalog.getDamageFromItemRange(char_show.mainHand) + char_show.stats["Constitution"][0])
		$"ColorRect/ColorRect/Weapon/+hit".text = "+" + str(char_show.stats["Strength"][0] + (char_show.prof_weapons[char_show.mainHand.itemName] * char_show.prof_bonus))
		char_show.mainHand.equiped = true
	elif item.itemType == "Armor" and item.equiped == false:
		if char_show.armor != null:
			char_show.armor.equiped = false
		char_show.armor = item
		item.owner = char_show
		char_show.armor_class = Catalog.getACfromArmor(char_show.armor, char_show)
		$ColorRect/ColorRect/Armor/armor_desc.text = char_show.armor.itemName
		char_show.armor.equiped = true
	
	updateInv()

func _on_equip_pressed() -> void:
	updateHandandArmor()
	if item.equiped:
		$ColorRect/ColorRect2/equip.text = "Unequip"
	else:
		$ColorRect/ColorRect2/equip.text = "Equip"
