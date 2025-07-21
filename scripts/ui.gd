extends Control

@onready var landmark: Label = $"TravelMenu"/landmarkmiles
@onready var milesTotal: Label = $"TravelMenu"/milestotal

func _process(delta: float) -> void:
	landmark.text = "Next Landmark: " + str(Global.landmarks[0].milesAway - Global.miles_total)
	milesTotal.text = "Miles Traveled: " + str(Global.miles_total)
	$"TravelMenu"/Speed.text = "Speed: " + Global.getSpeed()
	$"TravelMenu"/time.text = "Time: " + Global.getTime()
	$"TravelMenu"/weather.text = "Weather: " + Global.getWeather()
	$TravelMenu/food.text = "Food: " + str(Global.food) + " pounds"
	
	if Input.is_action_just_pressed("enter"):
		Global.run = false
		Global.inWagonMenu = true

	if (Global.inEquipMenu):
		$CharacterMenu.show()
	else:
		$CharacterMenu.hide()
	
	if (Global.inTradeMenu):
		$trade_menu.show()
	else:
		$trade_menu.hide()
	
	if (Global.inWagonMenu):
		$WagonContextMenu.show()
	else:
		$WagonContextMenu.hide()
	
	if Global.inTown and $TownMenu.hidden:
		get_tree().call_group("landmarks", "hide")
		$TravelMenu.hide()
		$TownMenu.show()
		$ColorRect.hide()
	else:
		get_tree().call_group("landmarks", "show")
		$TravelMenu.show()
		$TownMenu.hide()
		$ColorRect.show()
	
func uiMove():
	$Control.moveTrail(Global.current_speed)


func _on_equip_pressed() -> void:
	Global.inEquipMenu = true
	Global.load_inv = true
	Global.run = false
