extends Area2D

var game
var animation
var hud

func _ready():
	game = get_node("/root/game")
	animation = get_node("door closed/animation")
	hud = get_node("/root/game/hud")

func _on_exit_door_body_enter(body):
	if body.get_name() != "character":
		return
	if body.is_frozen():
		return
	if not hud.is_key_taken():
		hud.show_hint("Find a key to open the door")
		return
	if animation.is_playing():
		var pos = animation.get_pos()
		animation.play("open")
		animation.seek(pos)
	else:
		animation.play("open")
	hud.door_opening(true)

func _on_exit_door_body_exit(body):
	if body.get_name() != "character":
		return
	if body.is_frozen() or not hud.is_key_taken():
		return
	if animation.is_playing():
		var pos = animation.get_pos()
		animation.play_backwards("open")
		animation.seek(pos)
	else:
		animation.play_backwards("open")
	hud.door_opening(false)

func _on_animation_finished():
	if animation.get_pos() > 0: # Door open
		game.next_map()
