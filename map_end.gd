extends Area2D

var timer

func _ready():
	timer = get_tree().get_root().get_node("game/map end timer")

func _on_map_end_body_enter(body):
	if body.get_name() != "character":
		return
	timer.start()

func _on_map_end_body_exit(body):
	if body.get_name() != "character":
		return
	timer.stop()
