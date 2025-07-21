extends Node2D

@export var ui : Control

func _ready() -> void:
	Global.add_items()

func _process(delta: float) -> void:
	
	if Global.run and $Timer.is_stopped():
		$Timer.start()
	elif Global.run == false:
		$Timer.stop()


func _on_timer_timeout() -> void:
	Global.move()
	if Global.time_day != 3:	
		ui.uiMove()
