extends StaticBody2D
var compas_ui

func _ready():
	if has_node("/root/Tutorial/CompasUILayer/CompasUI"):
		compas_ui = get_node("/root/Tutorial/CompasUILayer/CompasUI")
	else:
		print("No se encontró CompasUI")
	$Area2D.connect("body_entered", Callable(self, "_on_area_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_area_body_exited"))

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		print("Jugador entró en zona Tamborhuesos: desincronizando")
		# Desfasaje entre 0.1 y 0.5 segundos
		compas_ui.desfasaje_tiempo = randf_range(0.5, 1.0)

func _on_area_body_exited(body):
	if body.is_in_group("player"):
		print("Jugador salió de Tamborhuesos: sincronización restaurada")
		compas_ui.desfasaje_tiempo = 0.0
