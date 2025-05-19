class_name Baco_Tutorial
extends CharacterBody2D

@export var gravity = 100
@export var jump_speed = 100
@export var speed = 100

@onready var animated_sprite = $Bako5
@onready var compas_ui = get_node("/root/Tutorial/CompasUILayer/CompasUI")
@onready var vida_ui = get_node("/root/Tutorial/CompasUILayer/VidaUI")

var moving := false
var current_tween: Tween = null
var ultima_direccion := Vector2.ZERO

var current_zone_limits = {
	"zona1": { "min": Vector2(125, 80), "max": Vector2(242, 190) },
	"zona2": { "min": Vector2(242, 128), "max": Vector2(385, 144) },
	"zona3": { "min": Vector2(365, 144), "max": Vector2(385, 239) },
	"zona4": { "min": Vector2(385, 224), "max": Vector2(530, 239) },
}
var zona_actual = "zona1"

var salida = 	Vector2(520, 232)

func _ready():
	if vida_ui:
		vida_ui.connect("game_over", Callable(self, "_on_game_over"))

func _on_game_over():
	get_tree().paused = true
	var game_over_ui = preload("res://CONTENT/NIVELES/Game_Over/Game_Over.tscn").instantiate()
	get_tree().get_root().add_child(game_over_ui)

func update_animations():
	if moving:
		if abs(ultima_direccion.x) > 0:
			animated_sprite.play("caminar")
			animated_sprite.flip_h = ultima_direccion.x < 0
		elif ultima_direccion.y < 0:
			animated_sprite.play("arriba")
		elif ultima_direccion.y > 0:
			animated_sprite.play("abajo")
	else:
		animated_sprite.play("Estatico")

func _physics_process(delta):
	update_animations()

	if not is_on_floor():
		velocity.y += gravity * delta

	if not moving and compas_ui:
		var beat_precision = compas_ui.get_beat_precision()

		if beat_precision != "fallo":
			var move_vector = Vector2.ZERO
			if Input.is_action_just_pressed("derecha"):
				move_vector.x += 48
			elif Input.is_action_just_pressed("izquierda"):
				move_vector.x -= 48
			elif Input.is_action_just_pressed("arriba"):
				move_vector.y -= 48
			elif Input.is_action_just_pressed("abajo"):
				move_vector.y += 48

			if move_vector != Vector2.ZERO:
				var target_position = position + move_vector
				var target_valid = false

				for zona in current_zone_limits.keys():
					var min_pos = current_zone_limits[zona]["min"]
					var max_pos = current_zone_limits[zona]["max"]
					if target_position.x >= min_pos.x and target_position.x <= max_pos.x \
					and target_position.y >= min_pos.y and target_position.y <= max_pos.y:
						target_valid = true
						break

				if target_valid:
					ultima_direccion = move_vector
					moving = true
					current_tween = create_tween()
					current_tween.tween_property(self, "position", target_position, 0.25)\
						.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
					current_tween.finished.connect(_on_tween_completed)

					# Cambios de vida según precisión del ritmo
					if vida_ui:
						if beat_precision == "perfecto":
							vida_ui.acierto_perfecto()
						elif beat_precision == "medio":
							vida_ui.perder_vida(0.5)
		else:
			# Fallo de ritmo
			if Input.is_action_just_pressed("derecha") or Input.is_action_just_pressed("izquierda") \
			or Input.is_action_just_pressed("arriba") or Input.is_action_just_pressed("abajo"):
				if vida_ui:
					vida_ui.perder_vida(1.0)


	velocity = Vector2.ZERO
	move_and_slide()
	actualizar_zona_actual()

	# Clamp de posición para no salirse de zona
	var min_pos = current_zone_limits[zona_actual]["min"]
	var max_pos = current_zone_limits[zona_actual]["max"]
	position.x = clamp(position.x, min_pos.x, max_pos.x)
	position.y = clamp(position.y, min_pos.y, max_pos.y)

	if position.distance_to(salida) < 5:
		get_tree().change_scene_to_file("res://CONTENT/NIVELES/MAPA/mapa.tscn")

func actualizar_zona_actual():
	for nombre_zona in current_zone_limits.keys():
		var min_pos = current_zone_limits[nombre_zona]["min"]
		var max_pos = current_zone_limits[nombre_zona]["max"]
		if position.x >= min_pos.x and position.x <= max_pos.x \
		and position.y >= min_pos.y and position.y <= max_pos.y:
			zona_actual = nombre_zona
			break

func _on_tween_completed():
	moving = false
	current_tween = null
	
