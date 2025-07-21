extends Node2D

@export var char1: CharacterBase
@export var char2: CharacterBase
@export var char3: CharacterBase
@export var char4: CharacterBase

@onready var battlemap = $BattleMap
@export var camera: CharacterBody2D
var show_actions := false
var show_magic := false

@onready var spellDesc = load("res://scripts/SpellDesc.gd").new()


func _process(delta: float) -> void:
	
	if battlemap.click_confirm:
		$CanvasLayer/Label4.show()
	else:
		$CanvasLayer/Label4.hide()
		
	if  battlemap.current_creature.isenemy == false and battlemap.current_creature.spell_slots["1st Level"][0] > 0:
		$CanvasLayer/ColorRect/spell_slot/slot_1.show()
		$CanvasLayer/ColorRect/spell_slot/slot_2.show()
		
		if battlemap.current_creature.spell_slots["1st Level"][1] == 1:
			$CanvasLayer/ColorRect/spell_slot/slot_1/fill.show()
			$CanvasLayer/ColorRect/spell_slot/slot_2/fill.hide()
		elif battlemap.current_creature.spell_slots["1st Level"][1] == 2:
			$CanvasLayer/ColorRect/spell_slot/slot_1/fill.show()
			$CanvasLayer/ColorRect/spell_slot/slot_2/fill.show()
		elif battlemap.current_creature.spell_slots["1st Level"][1] == 0:
			$CanvasLayer/ColorRect/spell_slot/slot_1/fill.hide()
			$CanvasLayer/ColorRect/spell_slot/slot_2/fill.hide()
	else:
		$CanvasLayer/ColorRect/spell_slot/slot_1.hide()
		$CanvasLayer/ColorRect/spell_slot/slot_2.hide()
		
	
	if SpellManager.cast_self:
		if battlemap.current_creature.inCon:
			$Label.text = "Will Break Concentration"
		else:
			$Label.text = "Click to cast on self"
		$Label.show()
		$Label.global_position = get_global_mouse_position()
	else:
		$Label.hide()
	
	if SpellManager.cast_click:
		$Label.text = "Click to cast"
		$Label.show()
		$Label.global_position = get_global_mouse_position()
	else:
		$Label.hide()
	
	if SpellManager.aoe_range == false and SpellManager.show_aoe:
		$Label.text = "Too far"
		$Label.show()
		$Label.global_position = get_global_mouse_position()
	
	if BattleManager.aiInPlay:
		get_tree().call_group("ui_char", "hide")
	elif $CanvasLayer/magic.hidden:
		get_tree().call_group("ui_char", "show")
	
	if battlemap.current_creature and battlemap.current_creature.hasAttacked:
		$CanvasLayer/attack.disabled = true
	else:
		$CanvasLayer/attack.disabled = false
	$CanvasLayer/ProgressBar.value = battlemap.current_creature.usedMovement
	$CanvasLayer/ProgressBar.max_value = battlemap.current_creature.speed
	$CanvasLayer/ProgressBar/Label.text = str(battlemap.current_creature.usedMovement) + "/" + str(battlemap.current_creature.speed)

	$CanvasLayer/Panel/textbox.text = BattleManager.text
	$CanvasLayer/attack.text = "ATTACK\n(" + battlemap.current_creature.mainHand.itemName + ")"
	
	if show_actions:
		$CanvasLayer/action/Panel.show()
	else:
		$CanvasLayer/action/Panel.hide()
	
	if show_magic:
		$CanvasLayer/magic/Panel.show()
	else:
		$CanvasLayer/magic/Panel.hide()
		
	if Input.is_action_just_pressed("cancel_action"):
		BattleManager.mode = 0
		SpellManager.spellCasting = "None"
		SpellManager.show_aoe = false
		
	if BattleManager.mode == 0:
		$CanvasLayer/Label.text = "Movement Mode"
	elif BattleManager.mode == 1:
		$CanvasLayer/Label.text = "Attack Mode"
	elif BattleManager.mode == 2:
		$CanvasLayer/Label.text = "Casting " + SpellManager.spellCasting
	
	if BattleManager.tooltip and BattleManager.tooltip_char and BattleManager.tooltip_type == "Char":
		$CanvasLayer/char_tooltip.show()
		if BattleManager.tooltip_char as CharacterBase:
			$CanvasLayer/char_tooltip/m_name.text = BattleManager.tooltip_char.char_name
			if BattleManager.tooltip_char.health == BattleManager.tooltip_char.health_cur:
				$CanvasLayer/char_tooltip/m_status.text = "Status: Healthy"
			elif BattleManager.tooltip_char.health_cur < BattleManager.tooltip_char.health / 3 :
				$CanvasLayer/char_tooltip/m_status.text = "Status: Heavily Injured"
			elif BattleManager.tooltip_char.health_cur < BattleManager.tooltip_char.health:
				$CanvasLayer/char_tooltip/m_status.text = "Status: Injured"
			$CanvasLayer/char_tooltip/chancehit.text = "AC: " + str(BattleManager.tooltip_char.armor_class)
		else:
			$CanvasLayer/char_tooltip/m_name.text = BattleManager.tooltip_char.mobName
			if BattleManager.tooltip_char.hp_cur == BattleManager.tooltip_char.hp:
				$CanvasLayer/char_tooltip/m_status.text = "Status: Healthy"
			elif BattleManager.tooltip_char.hp_cur < BattleManager.tooltip_char.hp / 3 :
				$CanvasLayer/char_tooltip/m_status.text = "Status: Heavily Injured"
			elif BattleManager.tooltip_char.hp_cur < BattleManager.tooltip_char.hp:
				$CanvasLayer/char_tooltip/m_status.text = "Status: Injured"
		
			$CanvasLayer/char_tooltip/chancehit.text = "Can hit: " + str(100 - int(( float(BattleManager.tooltip_char.armor_class - BattleManager.iReal[BattleManager.currentTurn][1].stats["Strength"][0]) / 20) * 100)) + "%" 
	elif BattleManager.tooltip and BattleManager.tooltip_char and BattleManager.tooltip_type == "Spell":
		$CanvasLayer/char_tooltip.show()
		$CanvasLayer/char_tooltip/m_name.text = BattleManager.tooltip_char
		$CanvasLayer/char_tooltip/m_status.text = spellDesc.spellDesc[BattleManager.tooltip_char]
		$CanvasLayer/char_tooltip/chancehit.text = ""
	else:
		$CanvasLayer/char_tooltip.hide()
		
	$CanvasLayer/Label3.text = str(battlemap.mouse_pos)

func _on_button_pressed() -> void:
	BattleManager.nextTurn()
	show_magic = false
	show_actions = false
	if battlemap.current_creature.isenemy == false:
		$CanvasLayer/magic.char = battlemap.current_creature
	$CanvasLayer/magic.setSpells()

func setUpBattleUI():
	
	for i in BattleManager.iReal:
		if (i[1].has_method("calAC")):
			$CanvasLayer/InitList.add_item(i[1].char_name)
		else:
			$CanvasLayer/InitList.add_item(i[1].mobName)

func _ready() -> void:
	setUpBattleUI()
	if battlemap.current_creature.isenemy == false:
		$CanvasLayer/magic.char = battlemap.current_creature
	$CanvasLayer/magic.setSpells()


func _on_attack_pressed() -> void:
	BattleManager.mode = 1


func _on_area_2d_mouse_entered() -> void:
	BattleManager.inUI = false


func _on_area_2d_mouse_exited() -> void:
	BattleManager.inUI = true


func _on_action_pressed() -> void:
	if show_actions:
		show_actions = false
	else:
		show_actions = true
		show_magic = false


func _on_dash_pressed() -> void:
	if battlemap.current_creature.hasAttacked == false:
		battlemap.current_creature.usedMovement += 5
		battlemap.current_creature.hasAttacked = true
		


func _on_magic_pressed() -> void:
	if show_magic:
		show_magic = false
	else:
		$CanvasLayer/magic.char = battlemap.current_creature
		$CanvasLayer/magic.setSpells()
		show_magic = true
		show_actions = false
