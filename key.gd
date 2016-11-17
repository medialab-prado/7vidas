extends Sprite

var taken = false

func _on_body_enter(body):
	if taken or body.get_name() != "character":
		return
	taken = true
	get_node("animation").play("taken")
	get_node("/root/game/hud").enable_key()
