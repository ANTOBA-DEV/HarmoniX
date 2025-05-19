extends StaticBody2D
var compas_ui

func _ready():
	compas_ui = get_node("/root/Tutorial/CompasUILayer/CompasUI")
	$Area2D.connect("body_entered", Callable(self, "_on_area_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_area_body_exited"))


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		print("Jugador entró en zona Murcibass")
		acelerar_ritmo()


func _on_area_body_exited(body):
	if body.is_in_group("player"):
		print("Jugador salió de zona Murcibass")
		desacelerar_ritmo()


func acelerar_ritmo():
	compas_ui.set_bpm(compas_ui.bpm * 1.5)

func desacelerar_ritmo():
	compas_ui.set_bpm(compas_ui.bpm / 1.5)
