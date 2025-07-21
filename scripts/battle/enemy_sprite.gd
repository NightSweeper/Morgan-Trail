extends Sprite2D

@export var enemy: MobBase
var inMouse = false
var ai_mode = "" # either melee, or ranged
var index
var isEnemy = true
var keep_moving = true
var aiMove = false
var mobs_around
var dead = false

var range1 = load("res://Battle Scenes/ranges/range1.tres")
var range16= load("res://Battle Scenes/ranges/range16.tres")
var range30 = load("res://Battle Scenes/ranges/range30.tres")

func setUp():
	$ProgressBar.max_value = enemy.hp_cur
	$ProgressBar.value = enemy.hp_cur
	texture = enemy.image
	
	if enemy.mainHand.itemName == "Shortbow":
		$mouseover/CollisionShape2D.shape = range16
	elif enemy.mainHand.itemName == "Longbow":
		$mouseover/CollisionShape2D.shape = range30
	else:
		$mouseover/CollisionShape2D.shape = range1

func _process(delta: float) -> void:
	$ProgressBar.value = enemy.hp_cur
	
func ai_move():
	if ai_mode == "Melee":
		melee()
	elif ai_mode == "Ranged":
		ranged()
	else:
		print("No ai set")

func melee():
	mobs_around = getCharactersAround()
	aiMove = true
	var astar = get_parent().astar
	print("ai move: melee")
	BattleManager.text += enemy.mobName + " moves\n"
	var pos = 0
	var temp = 10000
	
	for i in BattleManager.iReal:
		if (i[2].distance_squared_to(BattleManager.iReal[index][2]) < temp) and i[1].isenemy == false:
			temp = i[2].distance_squared_to(BattleManager.iReal[index][2])
			pos = i[2]
	
	
	var current_path: Array = astar.get_id_path(
		BattleManager.iReal[index][2], pos, true
	).slice(1)
	
	$Timer.wait_time = 0.5 * current_path.size()
	$Timer.start()
	while keep_moving:
		move(current_path)
		get_parent().updateMap()
	

func move(current_path):
	
	if current_path.is_empty() or enemy.usedMovement == 0:
		keep_moving = false
		aiMove = false
	else:
		var target_pos = get_parent().tilemap.map_to_local(current_path.front())
#		print(target_pos)
		var tween = get_tree().create_tween()
		
		tween.tween_property(self, "position", target_pos, 0.5)
		
		BattleManager.iReal[index][2] = current_path.front()
		current_path.pop_front()
		enemy.usedMovement -= 1
		
		if current_path.size() < 1:
			keep_moving = false


func ranged():
	print("ai move: ranged")
	$Timer.start()
	

func returnBodies():
	return $mouseover.get_overlapping_areas()

func getCharactersAround():
	return $oa.get_overlapping_areas()

func _on_area_2d_2_mouse_entered() -> void:
	inMouse = true
	BattleManager.tooltip = true
	BattleManager.tooltip_char = enemy
	BattleManager.tooltip_type = "Char"


func _on_area_2d_2_mouse_exited() -> void:
	inMouse = false
	BattleManager.tooltip = false
	BattleManager.tooltip_type = "None"

func attack():
	
	keep_moving = true
	var enemies = returnBodies()
	var intt = 0
	# Remove any allies
	while intt < enemies.size():
		if enemies[intt].get_parent().isEnemy:
			enemies.remove_at(intt)
		else:
			intt += 1
	
	var target = enemies.pick_random()
	
	if target:
		target = target.get_parent().char
		var roll = enemy.attackRoll(target)
		
		if (roll >= target.armor_class):
			var damage = enemy.attackDamage()
			BattleManager.text += enemy.mobName + " hits " + target.char_name + " for " + str(damage) + " damage" + "\n"
			target.health_cur -= damage
			enemy.hasAttacked = true
			BattleManager.mode = 0
			if target.health_cur <= 0:
				BattleManager.iReal[index][2] = Vector2i(-10,-10)
				print("character dead")
		else:
			BattleManager.text += enemy.mobName + " missed against " + target.char_name  + "(" + str(roll) + " vs " + str(target.armor_class) + ")" + "\n"
			enemy.hasAttacked = true
			BattleManager.mode = 0
	$Timer.stop()


func _on_timer_timeout() -> void:
	BattleManager.aiInPlay = false
	attack()

func _on_oa_area_exited(area: Area2D) -> void:
		
	if area.get_parent().isEnemy:
		return
	
	if aiMove == false:
		return
		
	if area.get_parent().char.health < 1 or enemy.hp_cur < 1 or dead:
		return
	
	print(enemy.hp_cur)
	var char: CharacterBase = area.get_parent().char
	
	var roll = char.attackRoll()
	if (roll >= enemy.armor_class):
		var damage = char.attackDamage()
		BattleManager.text += char.char_name + " hits " + enemy.mobName + " for " + str(damage) + " damage" + "\n"
		enemy.hp_cur -= damage
		char.usedReaction = true
		BattleManager.mode = 0
		if enemy.hp_cur <= 0:
			BattleManager.iReal[index][2] = Vector2i(-10,-10)
			dead = true
			free()
			get_parent().updateMap()
	else:
		BattleManager.text += char.char_name + " missed against " + enemy.mobName + "(" + str(roll) + " vs " + str(enemy.armor_class) + ")" + "\n"
		char.usedReaction = true
