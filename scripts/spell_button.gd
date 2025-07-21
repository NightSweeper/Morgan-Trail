extends Button


func _on_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().show_magic = false
	SpellManager.spellCastPrepare(text)


func _on_mouse_entered() -> void:
	BattleManager.tooltip = true
	BattleManager.tooltip_type = "Spell"
	BattleManager.tooltip_char = text


func _on_mouse_exited() -> void:
	BattleManager.tooltip = false
	BattleManager.tooltip_type = "None"
