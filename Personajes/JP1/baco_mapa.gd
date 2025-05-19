class_name baco_Mapa
extends CharacterBody2D

# Puntos del camino
var path_points = [
	Vector2(21, -12),
	Vector2(346,140),
	Vector2(567, 30),
	Vector2(456, -15),
	Vector2(567, 30),
	Vector2(667, -14),
	Vector2(567, 30),
	Vector2(772, 253)    
]

# Posiciones hacia niveles 
var levels = [
	Vector2(456, -15),
	Vector2(667, -14)
	]

var niveles_info = {
	levels[0]: "Presiona ENTER\n para ingresar al tutorial",
	levels[1]: "Presiona ENTER\n para el nivel 1"
}

# Valores de físicas
@export var gravity = 100
@export var speed = 250

# Animaciones
@onready var animated_sprite = $Bako5
@onready var label_nivel = $LabelNivel

# Movimiento automático
var current_index = 0
var target_position = Vector2.ZERO
var moving = false
var auto_move_direction = Vector2.ZERO


func _ready():
	if not GameState.mapa_iniciado:
		# Primera vez: iniciar desde el primer punto del camino
		position = path_points[0]
		GameState.ultima_posicion_mapa = position
		GameState.mapa_iniciado = true
	else:
		# Después de volver de un nivel o tutorial
		position = GameState.ultima_posicion_mapa

	# Buscar el punto más cercano para establecer el índice correcto
	var closest_index = 0
	var closest_distance = INF
	for i in path_points.size():
		var d = position.distance_to(path_points[i])
		if d < closest_distance:
			closest_distance = d
			closest_index = i
	current_index = closest_index
func _unhandled_input(event):
	if not moving:
		if Input.is_action_just_pressed("derecha") and current_index < path_points.size() - 1:
			current_index += 1
			move_to_point(current_index)
		elif Input.is_action_just_pressed("izquierda") and current_index > 0:
			current_index -= 1
			move_to_point(current_index)
		# Ingreo a niveles al dar enter
		elif Input.is_action_just_pressed("enter"):
			if position.distance_to(levels[0]) < 5:
				GameState.ultima_posicion_mapa = position
				get_tree().change_scene_to_file("res://CONTENT/NIVELES/Tutorial/tutorial.tscn")
			#elif position.distance_to(level_verde) < 5:
				#get_tree().change_scene_to_file("res://RUTA/DEL/NIVEL_VERDE.tscn") 



func move_to_point(index):
	target_position = path_points[index]
	auto_move_direction = (target_position - position).normalized()
	moving = true

func move_to_position(pos: Vector2):
	target_position = pos
	auto_move_direction = (target_position - position).normalized()
	moving = true

func update_animations():
	if velocity.y < -1:
		animated_sprite.play("arriba")
	elif abs(velocity.x) > 1:
		animated_sprite.play("caminar")
		animated_sprite.flip_h = velocity.x < 0
	else:
		animated_sprite.play("Estatico")
		animated_sprite.flip_h = false

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento automático
	if moving:
		var distance = position.distance_to(target_position)
		if distance > 5:
			velocity.x = auto_move_direction.x * speed
			velocity.y = auto_move_direction.y * speed
		else:
			position = target_position
			velocity = Vector2.ZERO
			moving = false

	else:
		velocity = Vector2.ZERO
		
	var cerca_de_nivel = false

	# Mostrar mensaje si está cerca de un nivel
	for nivel_pos in levels:
		if position.distance_to(nivel_pos) < 15:
			label_nivel.position = Vector2(24, -26)
			
			label_nivel.text = niveles_info.get(nivel_pos)
			
			label_nivel.visible = true
			cerca_de_nivel = true
			break
		else:
			label_nivel.visible = false


	move_and_slide()
	update_animations()
