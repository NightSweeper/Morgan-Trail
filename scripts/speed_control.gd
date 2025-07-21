extends Control


func _on_steady_pressed() -> void:
	Global.current_speed = Global.speed_steady


func _on_strenuous_pressed() -> void:
	Global.current_speed = Global.speed_strenous


func _on_grueling_pressed() -> void:
	Global.current_speed = Global.speed_grueling


func _on_slow_pressed() -> void:
	Global.current_speed = Global.speed_slow


func _on_stop_pressed() -> void:
	Global.current_speed = 0


func _on_button_pressed() -> void:
	Global.inWagonMenu = false
	Global.run = true
