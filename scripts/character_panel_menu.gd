extends Button

@export var char: CharacterBase

func _process(delta: float) -> void:
	$lvl.text = "LVL " + str(char.level)
	$Name_panel_small.text = char.char_name
	$class_panel_small.text = char.characterClass.getClassName()
