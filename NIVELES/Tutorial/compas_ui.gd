extends Control

# Este script va en CompasUI como antes
@onready var needle = $GradientBar/IndicadorRitmo
@export var needle_width := 4
@export var compas_ancho := 257
@export var bpm := 60.0

@onready var audio_player: AudioStreamPlayer = get_node("/root/Tutorial/AudioStreamPlayer")
@onready var vida_ui = $VidaUI

var desfasaje_tiempo := 0.0


func get_vida_ui():
	return vida_ui
	
func _ready():
	# Escalar visualmente el CompasUI
	scale = Vector2(2, 2)  # Cambiá esto al gusto

	# Centrar abajo dinámicamente según tamaño de pantalla
	var screen_size = get_viewport().size
	var self_size = size * scale  # Tener en cuenta el nuevo tamaño escalado

	# Centrar horizontalmente, anclar abajo
	position.x = (screen_size.x - self_size.x) / 2
	position.y = screen_size.y - self_size.y - 16  # margen inferior de 16px
	
	if audio_player and not audio_player.playing:
		audio_player.play()

func set_rhythm_position(norm_value: float) -> void:
	norm_value = clamp(norm_value, 0.0, 1.0)
	var pos_x = (compas_ancho - needle_width) * norm_value
	needle.position.x = pos_x

func _process(delta):
	if audio_player and audio_player.playing:
		var beat_duration = 60.0 / bpm
		# Offset de medio beat para que el centro (0.5) coincida con el inicio
		var offset = beat_duration * 0.5
		var time = audio_player.get_playback_position() + offset + desfasaje_tiempo
		var beat_pos = (fmod(time, beat_duration * 2.0)) / beat_duration
		if beat_pos > 1.0:
			beat_pos = 2.0 - beat_pos
		set_rhythm_position(beat_pos)

func is_on_beat() -> bool:
	var beat_duration = 60.0 / bpm
	var offset = beat_duration * 0.5
	var time = audio_player.get_playback_position() + offset + desfasaje_tiempo
	var beat_pos = fmod(time, beat_duration * 2.0) / beat_duration
	if beat_pos > 1.0:
		beat_pos = 2.0 - beat_pos
	return abs(beat_pos - 0.5) < 0.1  # tolerancia de +/- 0.1

func get_beat_precision() -> String:
	var beat_duration = 60.0 / bpm
	var offset = beat_duration * 0.5
	var time = audio_player.get_playback_position() + offset + desfasaje_tiempo
	var beat_pos = fmod(time, beat_duration * 2.0) / beat_duration
	if beat_pos > 1.0:
		beat_pos = 2.0 - beat_pos

	# Clasificación:
	var diferencia = abs(beat_pos - 0.5)
	if diferencia < 0.08:
		return "perfecto"
	elif diferencia < 0.3:
		return "medio"
	else:
		return "fallo"
		
func set_bpm(new_bpm: float) -> void:
	bpm = new_bpm
	if audio_player:
		audio_player.pitch_scale = new_bpm / 60.0  # 60 es tu BPM base
