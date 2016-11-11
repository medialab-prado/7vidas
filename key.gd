extends Area2D

var taken = false
export var color = 0

func _ready():
	get_node("sprite").set_frame(color)

func _on_body_enter(body):
	if taken or body.get_name() != "character":
		return
	taken = true
	get_node("sprite/animation").play("taken")
	get_node("/root/game/hud").enable_key(color)
