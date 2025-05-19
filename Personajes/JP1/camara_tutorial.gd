extends Camera2D

@export var seguir_personaje:Node2D


func _process(delta):
	position = seguir_personaje.position
