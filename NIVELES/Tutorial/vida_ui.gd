extends Control

const CORAZON_COMPLETO = preload("res://CONTENT/SPRITTES/Personajes/VIDA/Full.png")
const MEDIO_CORAZON = preload("res://CONTENT/SPRITTES/Personajes/VIDA/Half.png")
const CORAZON_VACIO = preload("res://CONTENT/SPRITTES/Personajes/VIDA/Empty.png")

const CORAZONES_MAXIMOS = 5
var vida_actual: float = CORAZONES_MAXIMOS

var corazones = []
var aciertos_perfectos_seguidos = 0

@onready var hbox = $HBoxContainer  # ← Asegúrate que el nodo se llama así

signal game_over

func _ready():
	crear_corazones()
	actualizar_corazones()

func crear_corazones():
	for i in CORAZONES_MAXIMOS:
		var corazon = TextureRect.new()
		corazon.texture = CORAZON_COMPLETO
		corazon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		corazon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		corazon.custom_minimum_size = Vector2(32, 32) # Ajusta según tu sprite
		hbox.add_child(corazon)  # ← Añadir al HBoxContainer
		corazones.append(corazon)

func actualizar_corazones():
	var vida = vida_actual
	for i in corazones.size():
		if vida >= 1.0:
			corazones[i].texture = CORAZON_COMPLETO
		elif vida >= 0.5:
			corazones[i].texture = MEDIO_CORAZON
		else:
			corazones[i].texture = CORAZON_VACIO
		vida -= 1.0

func perder_vida(cantidad: float):
	vida_actual = max(vida_actual - cantidad, 0)
	aciertos_perfectos_seguidos = 0
	actualizar_corazones()
	
	if vida_actual <= 0:
		emit_signal("game_over")
		
func acierto_perfecto():
	aciertos_perfectos_seguidos += 1
	if aciertos_perfectos_seguidos >= 5 and vida_actual < CORAZONES_MAXIMOS:
		vida_actual = min(vida_actual + 0.5, CORAZONES_MAXIMOS)
		aciertos_perfectos_seguidos = 0
	actualizar_corazones()
