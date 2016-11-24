extends Sprite

var taken = false
var hud

func _ready():
	hud = get_node("/root/game/hud")

func _on_body_enter(body):
	if taken or body.get_name() != "character":
		return
	taken = true
	get_node("animation").play("taken")
	hud.enable_key()
