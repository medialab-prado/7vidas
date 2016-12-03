extends Sprite

var taken = false
var hud
var animation

func _ready():
	hud = get_node("../../hud")
	animation = get_node("animation")

func _on_body_enter(body):
	if taken or body.get_name() != "character":
		return
	taken = true
	animation.play("taken")
	hud.enable_key()
