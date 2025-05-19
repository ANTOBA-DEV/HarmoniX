extends CanvasLayer
@onready var btn_volver = $Panel/VolverMapa
@onready var btn_reintentar = $Panel/Reintentar

func _ready():
	
	btn_volver.pressed.connect(_on_volver_pressed)
	btn_reintentar.pressed.connect(_on_reintentar_pressed)

func _on_volver_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://CONTENT/NIVELES/MAPA/mapa.tscn")

func _on_reintentar_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().reload_current_scene()
