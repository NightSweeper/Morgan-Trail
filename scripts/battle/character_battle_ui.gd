extends ColorRect

@export var character: CharacterBase

func _ready() -> void:
	
	$c_name.text = character.char_name + " - " + character.characterClass.getClassName()
	
	$ProgressBar.max_value = character.health
	$ProgressBar.value = character.health_cur
	$ProgressBar/Label.text = str(character.health_cur)

func _process(delta: float) -> void:
	if BattleManager.iReal[BattleManager.currentTurn][1].has_method("calAC"):
		character = BattleManager.iReal[BattleManager.currentTurn][1]
	
		$c_name.text = character.char_name 
		$c_name2.text = character.characterClass.getClassName()
	
		$ProgressBar.max_value = character.health
		$ProgressBar.value = character.health_cur
		$ProgressBar/Label.text = str(character.health_cur)
	else:
		pass
