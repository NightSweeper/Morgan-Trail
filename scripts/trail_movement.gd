extends Control

func moveTrail(miles:int):
	position = lerp(position, Vector2(position.x + (miles*10), position.y), 1)
	
