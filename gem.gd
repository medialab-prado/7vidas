extends Sprite

var taken = false
var animation
var hud

func _ready():
	animation = get_node("animation")
	hud = get_node("../../hud")

func _on_body_enter(body):
	if taken or body.get_name() != "character":
		return
	taken = true
	animation.play("taken")
	if get_frame() == 0:
		hud.time_bonus(20)
	elif get_frame() == 1:
		hud.time_bonus(5)
