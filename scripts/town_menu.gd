extends ColorRect


func _process(delta: float) -> void:
	$time.text = "Time: " + Global.getTime()
	$location.text = Global.town.townName
	$Gold.text = "Gold: " + str(Global.gold)
	$Food.text = "Food: " + str(Global.food) + " pounds"
	

func _on_leave_pressed() -> void:
	Global.inTown = false
	Global.run = true


func _on_equip_pressed() -> void:
	Global.inEquipMenu = true
	Global.load_inv = true


func _on_trade_pressed() -> void:
	Global.inTradeMenu = true
