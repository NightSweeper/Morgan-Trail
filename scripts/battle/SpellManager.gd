extends Node

#  Should hopefully hold all the logic for each spell
var spellCasting := "None"
var show_aoe := false
var cast_self := false
var cast_click := false
var aoe_self := false
var aoe_range := false

# Ranges
var range5 = load("res://Battle Scenes/spell_ranges/range5ft.tres")
var range120 = load("res://Battle Scenes/spell_ranges/range120ft.tres")
var range30 = load("res://Battle Scenes/spell_ranges/range30ft.tres")
var cone15ft = load("res://Battle Scenes/spell_ranges/cone15ft.tres")
var cone15ft_s = load("res://assets/ranges/cone15ft.png")
var range5_s = load("res://assets/ranges/5ft_radius_circle.png")
var range60 = load("res://Battle Scenes/spell_ranges/range60ft.tres")
var range90 = load("res://Battle Scenes/spell_ranges/range90ft.tres")


func spellCastPrepare(spell_name : String):
	
	BattleManager.mode = 2
	
	spellCasting = spell_name
	
	match spell_name:
		# Cantrips
		"Fire Bolt":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range120
			print("Fire Bolt")
		"Blade Ward":
			cast_self = true
			print("Blade Ward")
		"Acid Splash":
			show_aoe = true
			BattleManager.iSprites[BattleManager.currentTurn].aoe_shape.shape = range5
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range60
			BattleManager.iSprites[BattleManager.currentTurn].sprite_aoe.texture = range5_s
			print("Acid Splash")
		"Chill Touch":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range5
			print("Chill Touch")
		"Mind Sliver":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range60
			print("Mind Sliver")
		"Poison Spray":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range30
			print("Poison Spray")
		"Primal Savagery":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range5
			print("Primal Savagery")
			
		# Spells 1
		"Bless":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range30
			cast_click = true
			print("Bless")
		"Burning Hands":
			BattleManager.iSprites[BattleManager.currentTurn].aoe_shape.shape = cone15ft
			BattleManager.iSprites[BattleManager.currentTurn].sprite_aoe.texture = cone15ft_s
			aoe_self = true
			print("Burning Hands")
		"Chromatic Orb":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range90
			print("Chromatic Orb")
		"Cure Wounds":
			BattleManager.iSprites[BattleManager.currentTurn].spell_range.shape = range5
			cast_click = true
			print("Cure Wounds")
		_:
			print("No Spell")


func spellCast(units: Array, current_unit: CharacterBase):
	
	match spellCasting:
			# Cantrips
		"Fire Bolt":
			print("Casting Fire Bolt")
			clickedUnit(units, current_unit, 10, 1)
		"Blade Ward":
			current_unit.conditions["Blade Ward"] = true
			current_unit.hasAttacked = true
			cast_self = false
			current_unit.inCon = true
			print("Casting Blade Ward")
		"Acid Splash":
			units[BattleManager.currentTurn].aoe_shape.shape = range5
			aoeUnits(units, current_unit, 6, 1, true,"Dexterity", false, "Blob of Acid")
			print("Casting Acid Splash")
		"Chill Touch":
			clickedUnit(units, current_unit, 10)
			print("Casting Chill Touch")
		"Mind Sliver":
			clickedUnit(units, current_unit, 6, 1, true, "Intelligence")
			print("Casting Mind Silver")
		"Poison Spray":
			clickedUnit(units, current_unit, 12, 1, false)
			print("Casting Poison Spray")
		"Primal Savagery":
			clickedUnit(units, current_unit, 10, 1)
			print("Casting Primal Savagery")
		# Spells 1
		"Bless":
			if current_unit.spell_slots["1st Level"][1] != 0:
				current_unit.hasAttacked = true
				current_unit.conditions["Blade Ward"] = false
				current_unit.inCon = true
				bless(units, current_unit)
				cast_click = false
				current_unit.spell_slots["1st Level"][1] -= 1
				print("Casting Bless")
		"Burning Hands":
			if current_unit.spell_slots["1st Level"][1] != 0:
				aoeUnits(units, current_unit, 6, 3, true, "Dexterity", true, "Cone of Fire")
				print("Casting Burning Hands")
		"Chromatic Orb":
			if current_unit.spell_slots["1st Level"][1] != 0:
				clickedUnit(units, current_unit, 6, 3)
				current_unit.spell_slots["1st Level"][1] -= 1
				print("Casting Chromatic Orb")
		"Cure Wounds":
			if current_unit.spell_slots["1st Level"][1] != 0:
				cureWounds(units, current_unit)
				current_unit.spell_slots["1st Level"][1] -= 1
				cast_click = false
				print("Casting Cure Wounds")
		_:
			print("No Match")
	
	spellCasting = "None"

func bless(units: Array, current_unit: CharacterBase):
	
	for unit in units:
		if units[BattleManager.currentTurn].returnBodiesSpell().has(unit.get_node("Area2D2")) and unit.isEnemy == false and current_unit != unit.char:
			unit.char.conditions["Bless"] = true
			
			BattleManager.text += current_unit.char_name + " casts bless" + "\n"
	current_unit.hasAttacked = true
 	
func cureWounds(units: Array, current_unit: CharacterBase):
	
	var rand = RandomNumberGenerator.new()
	var hp = 0
	for j in 2: 
		hp += rand.randi_range(1,8)
	
	hp += current_unit.stats[current_unit.casting_ability][0]
	for i in units:
			if i.inMouse and i.isEnemy == false:
				print("In mouse")
				if units[BattleManager.currentTurn].returnBodiesSpell().has(i.get_node("Area2D2")):
					var mob = i.char
					mob.health_cur += hp
					if mob.health_cur > mob.health:
						
						mob.health_cur = mob.health
					BattleManager.text += current_unit.char_name + " heals " + mob.char_name + " for " + str(hp) + " hp" + "\n"
	current_unit.hasAttacked = true
	
				

# For specific spells
func clickedUnit(units: Array, current_unit: CharacterBase, damage_max := 0, dice := 1,  spell_save := false, save_ability := "None"):
	
	var rand = RandomNumberGenerator.new()
	var index = 0
	for i in units:
			if i and i.inMouse:
				print("In mouse")
				if units[BattleManager.currentTurn].returnBodiesSpell().has(i.get_node("Area2D2")):
					# Ranged Attack
					var roll = current_unit.magicRoll()
					var mob
					if i.isEnemy:
						mob = i.enemy
					else:
						mob = i.char
					
					if (roll >= mob.armor_class and spell_save == false):
						
						var damage = 0
						rand.randomize()
						for j in dice: 
							damage += rand.randi_range(1,damage_max)
						if i.isEnemy:
							BattleManager.text += current_unit.char_name + " hits " + mob.mobName + " for " + str(damage) + " damage" + "\n"
							mob.hp_cur -= damage
							if mob.hp_cur <= 0:
								BattleManager.iReal[index][2] = Vector2i(-10,-10)
								i.dead = true
								i.free()
						else:
							BattleManager.text += current_unit.char_name + " hits " + mob.char_name + " for " + str(damage) + " damage" + "\n"
							mob.health_cur -= damage
						current_unit.hasAttacked = true
						BattleManager.mode = 0
						
					# Spell Save Logic
					elif spell_save:
						
						roll = 0
						rand.randomize()
						if i.isEnemy:
							mob = i.enemy
						else:
							mob = i.char
							
						var add = 0
						var sub = 0
						if mob.conditions["Bless"]:
							add = rand.randi_range(1,4)
							print("Thank god for bless")
						if mob.conditions["Mind Sliver"]:
							sub = rand.randi_range(1,4)
							print("Mind Attack!")
						roll = rand.randi_range(1,20) + mob.stats[save_ability][0] + add - sub
						
						if roll < current_unit.spell_save_dc:
							var damage = 0
							rand.randomize()
							for j in dice: 
								damage += rand.randi_range(1,damage_max)
							if i.isEnemy:
								BattleManager.text += current_unit.char_name + " hits " + mob.mobName + " for " + str(damage) + " damage" + "\n"
								mob.hp_cur -= damage
								if spellCasting == "MindSliver":
									mob.conditions["Mind Sliver"] = true
								if mob.hp_cur <= 0:
									BattleManager.text += current_unit.char_name + " kills " + mob.mobName
									BattleManager.iReal[index][2] = Vector2i(-10,-10)
									i.dead = true
									i.free()
							else:
								BattleManager.text += current_unit.char_name + " hits " + mob.char_name + " for " + str(damage) + " damage" + "\n"
								mob.health_cur -= damage
						else:
							if spell_save:
								if i.isEnemy:
									BattleManager.text += i.enemy.mobName + " succeeds a " + save_ability + " save against " +  current_unit.char_name +  "(" + str(current_unit.spell_save_dc) + " vs " + str(roll) + ")" + "\n"
						
								else:
									BattleManager.text += mob.char_name + " succeeds a " + save_ability + " save against " +  current_unit.char_name +  "(" + str(current_unit.spell_save_dc) + " vs " + str(roll) + ")" + "\n"
						
							current_unit.hasAttacked = true
							BattleManager.mode = 0
							
					else:
						if i.isEnemy:
							BattleManager.text += current_unit.char_name + " missed against " + mob.mobName + "(" + str(roll) + " vs " + str(mob.armor_class) + ")" + "\n"
						else:
							BattleManager.text += current_unit.char_name + " missed against " + mob.char_name + "(" + str(roll) + " vs " + str(mob.armor_class) + ")" + "\n"
						
						current_unit.hasAttacked = true
						BattleManager.mode = 0
						
			index += 1
	
# For AOE spells
func aoeUnits(units: Array, current_unit: CharacterBase, damage_max := 0, dice := 1,  spell_save := false, save_ability := "None", half_save := false, flavor_text: String = "None"):
	
	var mobs: Array = units[BattleManager.currentTurn].returnAOE()
	print(mobs)
	var rand = RandomNumberGenerator.new()
	var mobs_script: Array = []
	for i in mobs:
		mobs_script.append(i.get_parent())
	print(mobs_script)
	
	if mobs.size() == 0:
		return
	
	if aoe_range == false:
		print("Too far")
		return
	
	print(half_save)
	
	var index = 0
	for mob in mobs_script:
		var roll = 0
		var em
		if mob.isEnemy:
			em = mob.enemy
		else:
			em = mob.char
			
		if em != current_unit:

			if spell_save:
				var sub = 0
				var add = 0
				rand.randomize()
				roll = rand.randi_range(1,20) + em.stats[save_ability][0]
				
				if mob.conditions["mind Sliver"]:
					sub = rand.randi_range(1,4)
					print("Mind Attack!")
				
				if mob.conditions["Bless"]:
					add = rand.randi_range(1,4)
					print("Thank god for bless")
				
				if roll < current_unit.spell_save_dc:
					var damage = 0
					rand.randomize()
					for i in dice: 
						damage += rand.randi_range(1,damage_max)
					if flavor_text == "None":
						if mob.isEnemy:
							BattleManager.text += current_unit.char_name + " hits " + em.mobName + " for " + str(damage) + " damage" + "\n"
						else:
							BattleManager.text += current_unit.char_name + " hits " + em.char_name + " for " + str(damage) + " damage" + "\n"
					else:
						if mob.isEnemy:
							BattleManager.text += flavor_text + " hits " + em.mobName + " for " + str(damage) + " damage" + "\n"
						else:
							BattleManager.text += flavor_text + " hits " + em.char_name + " for " + str(damage) + " damage" + "\n"
					
					if mob.isEnemy:
						
						em.hp_cur -= damage
						if em.hp_cur <= 0:
							BattleManager.iReal[index][2] = Vector2i(-10,-10)
							mob.dead = true
							mob.free()
							BattleManager.text += flavor_text + " kills " + em.mobName + " for " + str(damage) + " damage" + "\n"
					else:
						em.health_cur -= damage
						
					current_unit.hasAttacked = true
					BattleManager.mode = 0
				else:
					if mob.isEnemy:
						var damage = 0
						BattleManager.text += em.mobName + " saves against " + spellCasting + " (" + str(current_unit.spell_save_dc) + " vs " + str(roll) + ")" + "\n"
						if half_save:
							rand.randomize()
							for i in dice: 
								damage += rand.randi_range(1,damage_max)
							BattleManager.text += em.mobName + " takes half of " + str(damage) + " (" + str(damage/2) + ")" + "\n"
							em.hp_cur -= damage/2
							
					else:
						var damage = 0
						BattleManager.text += em.char_name + " saves against " + spellCasting + " (" + str(current_unit.spell_save_dc) + " vs " + str(roll) + ")" + "\n"
						if half_save:
							rand.randomize()
							for i in dice: 
								damage += rand.randi_range(1,damage_max)
							BattleManager.text += em.char_name + " takes half of " + str(damage) + " (" + str(damage/2) + ")"  + "\n"
							em.health_cur -= damage/2
					
					current_unit.hasAttacked = true
			else:
				print("Error")
			
		index += 1
	
	
	SpellManager.show_aoe = false
	SpellManager.aoe_self = false
		
	
	
