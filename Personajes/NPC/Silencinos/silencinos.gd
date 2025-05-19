extends StaticBody2D
var compas_ui
var audio_player
var stop_timer = null

func _ready():
	compas_ui = get_node("/root/Tutorial/CompasUILayer/CompasUI")
	audio_player = get_node("/root/Tutorial/AudioStreamPlayer")
	$".".visible = false
	
	$Area2D.connect("body_entered", Callable(self, "_on_area_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_area_body_exited"))

	stop_timer = Timer.new()
	stop_timer.one_shot = true
	add_child(stop_timer)
	stop_timer.connect("timeout", Callable(self, "_on_stop_timeout"))

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		$".".visible = true
		print("Jugador entró en zona Silencinos")
		_detener_musica_y_compas()

func _on_area_body_exited(body):
	if body.is_in_group("player"):
		$".".visible = false
		print("Jugador salió de la zona Silencinos")

func _detener_musica_y_compas():
	if audio_player.playing:
		audio_player.stream_paused = true
	compas_ui.set_bpm(0)
	compas_ui.set_process(false)
	
	var tiempo_aleatorio = randi_range(3, 10)
	stop_timer.start(tiempo_aleatorio)

func _on_stop_timeout():
	print("Silencinos termina silencio, música y compás vuelven")
	audio_player.stream_paused = false
	compas_ui.set_bpm(60)  # o el bpm base que uses normalmente
	compas_ui.set_process(true)
