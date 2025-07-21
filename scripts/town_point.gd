extends Control

@export var town_icon : CompressedTexture2D

func _ready() -> void:
	$Sprite2D.texture = town_icon
