extends Sprite

var taken = false
var game
var animation
var hud
var character

func _ready():
	game = get_node("/root/game")
	animation = get_node("animation")
	hud = get_node("../../hud")
	character = get_node("../../character")

func _on_body_enter(body):
	if taken or body.get_name() != "character":
		return
	taken = true
	animation.play("taken")
	var gem_type = get_frame()
	if gem_type == 0:
		hud.time_bonus(20)
	elif gem_type == 1:
		hud.time_bonus(5)
	elif gem_type == 2:
		if game:
			var new_actor = game.extra_life()
			character.change_actor(new_actor)
			hud.update_extra_lives()
