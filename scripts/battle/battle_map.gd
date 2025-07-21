extends Control

var enemy_sprite = preload("res://enemy_sprite.tscn")

@export_category("Fight Encounter")
@export var fight : RandomFight

@export var char1: CharacterBase
@export var char2: CharacterBase
@export var char3: CharacterBase
@export var char4: CharacterBase

@export_category("Character Positions")
@export var char1_pos: Vector2
@export var char2_pos: Vector2
@export var char3_pos: Vector2
@export var char4_pos: Vector2
var current_creature 
@export var tilemap: TileMapLayer

var mouse_pos := Vector2()
var target_pos := Vector2()
var image_array_init = []

var astar = AStarGrid2D.new()
var current_path 
var view_path
var keep_moving = false
var move_step = false
var inUI = false
var click_confirm = false

func _ready() -> void:
	mouse_pos = $TileMapLayer.local_to_map(get_local_mouse_position())
	target_pos = $TileMapLayer.local_to_map(get_local_mouse_position())
	image_array_init = [$Character1, $Character2, $Character3, $Character4]
	loadmap()
	setUpIcons()
	setUpBattle()
	updateMap()
	current_creature = BattleManager.iReal[BattleManager.currentTurn][1]

func _process(delta: float) -> void:
	
	current_creature = BattleManager.iReal[BattleManager.currentTurn][1]
	BattleManager.iSprites = image_array_init
	get_tree().call_group("character_battle", "hideAoe")
	
	if image_array_init[BattleManager.currentTurn] and image_array_init[BattleManager.currentTurn].isEnemy == false and SpellManager.show_aoe:
		image_array_init[BattleManager.currentTurn].aoe.show()
		image_array_init[BattleManager.currentTurn].aoe.global_position = $highlight.global_position + Vector2(32,32)

	
	if image_array_init[BattleManager.currentTurn] and image_array_init[BattleManager.currentTurn].isEnemy == false and SpellManager.aoe_self:
		image_array_init[BattleManager.currentTurn].aoe.show()
		image_array_init[BattleManager.currentTurn].aoe.global_position = image_array_init[BattleManager.currentTurn].global_position
		image_array_init[BattleManager.currentTurn].sprite_aoe.centered = false
		image_array_init[BattleManager.currentTurn].sprite_aoe.offset = Vector2(0, -48)
		image_array_init[BattleManager.currentTurn].aoe.look_at(get_global_mouse_position())
	elif image_array_init[BattleManager.currentTurn] and image_array_init[BattleManager.currentTurn].isEnemy == false:
		image_array_init[BattleManager.currentTurn].sprite_aoe.centered = true
		image_array_init[BattleManager.currentTurn].sprite_aoe.offset = Vector2(0, 0)
		
	
	if image_array_init[BattleManager.currentTurn] and BattleManager.ai_move and image_array_init[BattleManager.currentTurn].isEnemy:
		get_parent().camera.position = $TileMapLayer.map_to_local(BattleManager.iReal[BattleManager.currentTurn][2])
		image_array_init[BattleManager.currentTurn].ai_move()
		BattleManager.ai_move = false
		BattleManager.nextTurn()
	
	if image_array_init[BattleManager.currentTurn] and image_array_init[BattleManager.currentTurn].aiMove:
		get_parent().camera.position = image_array_init[BattleManager.currentTurn].position
		
	
	mouse_pos = $TileMapLayer.local_to_map(get_local_mouse_position())
	$highlight.position = $TileMapLayer.map_to_local(mouse_pos) - Vector2(16,16)
	$turn.position = $TileMapLayer.map_to_local(BattleManager.iReal[BattleManager.currentTurn][2]) - Vector2(16,16)
	
	if Input.is_action_just_pressed("move_click") and BattleManager.inUI == false:
		keep_moving = true
		move_step = true
		$Timer.start()
		target_pos = $TileMapLayer.local_to_map(get_local_mouse_position())
		
	if keep_moving and move_step:
		animMove(target_pos)
		
	if BattleManager.inUI == false:
		view_path = astar.get_id_path(
			Vector2i(BattleManager.iReal[BattleManager.currentTurn][2]), mouse_pos
		)
	view_path = view_path.map($TileMapLayer.map_to_local)
	if view_path.size() < current_creature.usedMovement + 2:
		$Line2D.points = view_path
	else:
		$Line2D.clear_points()
	
	if Input.is_action_pressed("attack") and current_creature.hasAttacked == false and BattleManager.mode == 1:
		attack()
	
	if Input.is_action_just_pressed("attack") and current_creature.hasAttacked == false and BattleManager.mode == 2 and SpellManager.spellCasting != "None":
		
		if click_confirm == false:
			click_confirm = true
		else:
			click_confirm = false
			magic()

func magic():
	SpellManager.spellCast(image_array_init, current_creature)


func attack():
	var index = 0
	for i in image_array_init:
		
			if i and i.inMouse:
				
				if image_array_init[BattleManager.currentTurn].returnBodies().has(i.get_node("Area2D2")):
					
					var roll = current_creature.attackRoll()
					if (roll >= i.enemy.armor_class):
						var damage = current_creature.attackDamage()
						BattleManager.text += current_creature.char_name + " hits " + i.enemy.mobName + " for " + str(damage) + " damage" + "\n"
						i.enemy.hp_cur -= damage
						current_creature.hasAttacked = true
						BattleManager.mode = 0
						if i.enemy.hp_cur <= 0:
							BattleManager.iReal[index][2] = Vector2i(-10,-10)
							i.dead = true
							i.free()
							updateMap()
					else:
						BattleManager.text += current_creature.char_name + " missed against " + i.enemy.mobName + "(" + str(roll) + " vs " + str(i.enemy.armor_class) + ")" + "\n"
						current_creature.hasAttacked = true
						BattleManager.mode = 0
			index += 1

func setUpIcons():
	
	$Character1.position= $TileMapLayer.map_to_local(char1_pos)
	$Character2.position= $TileMapLayer.map_to_local(char2_pos)
	$Character3.position= $TileMapLayer.map_to_local(char3_pos)
	$Character4.position= $TileMapLayer.map_to_local(char4_pos)
	
func setUpBattle():
	
	char1.setUp()
	char2.setUp()
	char3.setUp()
	char4.setUp()
	
	BattleManager.iOrder.append([char1, char1_pos])
	BattleManager.iOrder.append([char2, char2_pos])
	BattleManager.iOrder.append([char3, char3_pos])
	BattleManager.iOrder.append([char4, char4_pos])
	
	var index = 0
	for i in fight.enemies:
		i[0].setUp()
		var mob = i[0].duplicate(true)
		mob.setUp()
		var enemy_i = enemy_sprite.instantiate()
		add_child(enemy_i)
		enemy_i.enemy = mob
		enemy_i.setUp()
		enemy_i.ai_mode = fight.enemy_mode[index]
		index += 1
		enemy_i.position = $TileMapLayer.map_to_local(i[1])
		BattleManager.iOrder.append([mob, i[1]])
		image_array_init.append(enemy_i)
	
	BattleManager.initiativeOrder()
	
	var temp = []
	for i in BattleManager.iReal:
		for j in image_array_init:
			if Vector2i(i[2]) == $TileMapLayer.local_to_map(j.position):
				temp.append(j)
	
	image_array_init = temp
	index = 0
	for i in image_array_init:
		i.index = index
		index += 1
	

func animMove(coords : Vector2):
	#BattleManager.iReal[BattleManager.currentTurn][2] = coords
	#image_array_init[BattleManager.currentTurn].position = $TileMapLayer.map_to_local(coords)
		
		
	current_path = astar.get_id_path(
		Vector2i(BattleManager.iReal[BattleManager.currentTurn][2]), coords
	).slice(1)
	
	if current_path.is_empty() or current_creature.usedMovement == 0:
		keep_moving = false
	else:
		
		var target_pos = $TileMapLayer.map_to_local(current_path.front())
#		print(target_pos)
		var tween = get_tree().create_tween()

		tween.tween_property(image_array_init[BattleManager.currentTurn], "position", target_pos, 0.1)

		
		if image_array_init[BattleManager.currentTurn].position == target_pos:
			BattleManager.iReal[BattleManager.currentTurn][2] = current_path.front()
			current_path.pop_front()
			current_creature.usedMovement -= 1
		
		
		if current_path.size() < 1:
			keep_moving = false
		
	move_step = false
	updateMap()
		
func updateMap():
	#Nav Compments
	var tilemap_size = $TileMapLayer.get_used_rect()
	var map_rect = tilemap_size
	
	
	for i in range(tilemap_size.position.x, tilemap_size.size.x):
		for j in range(tilemap_size.position.y, tilemap_size.size.y):
			var coords = Vector2i(i,j)
			var tile_data = $TileMapLayer.get_cell_tile_data(coords)
			astar.set_point_solid(Vector2i(i, j), false)
	
	for i in BattleManager.iReal:
		astar.set_point_solid(i[2], true)
	
	

func loadmap():
	
	#Nav Compments
	var tilemap_size = $TileMapLayer.get_used_rect()
	var map_rect = tilemap_size
	
	var tile_size = tilemap_size
	
	astar.region = map_rect
	astar.cell_size = tile_size.size
	
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	#Creates Solids in astar
	for i in range(tilemap_size.position.x, tilemap_size.size.x):
		for j in range(tilemap_size.position.y, tilemap_size.size.y):
			var coords = Vector2i(i,j)
			var tile_data = $TileMapLayer.get_cell_tile_data(coords)
			


func _on_timer_timeout() -> void:
	move_step = true

func checkTile(tile: Vector2i):
	return astar.is_point_solid(tile)
