extends Area2D

var timer
var animation
var hud

func _ready():
	timer = get_node("/root/game/map exit timer")
	animation = get_node("door closed/animation")
	hud = get_node("/root/game/hud")

func _on_map_end_body_enter(body):
	if body.get_name() != "character":
		return
	if not hud.key_taken:
		return
	timer.start()
	animation.play("open")

func _on_map_end_body_exit(body):
	if body.get_name() != "character":
		return
	if body.is_frozen():
		return
	timer.stop()
	var pos = animation.get_pos()
	animation.play_backwards("open")
	animation.seek(pos)
