extends Node

var game
var animJump
var animMove
var animInsert
var mytimer
var is_waiting = false

func _ready():
	game = get_node("/root/game")
	if game and game.medialab_facade:
		set_scale(Vector2(0.25, 0.25))
		
	animJump = get_node("JumpSprite/AnimationJump")
	animJump.play("JUMP")
	
	animMove = get_node("MoveSprite/AnimationMove")
	animMove.play("MOVE")
	
	animInsert = get_node("LabelInsert/AnimationInsert")
	animInsert.play("Flickering")

	if game:
		game.initial_scene_ready = true

func _on_timeout():
	game.start_game()

func on_players_waiting():
	mytimer = get_node("Timer")
	if is_waiting:
		return
	var new_time_left = mytimer.get_time_left() - (mytimer.get_wait_time() - 5)
	if new_time_left < 0.5:
		game.start_game()
	else:
		mytimer.stop()
		mytimer.set_wait_time(new_time_left)
		mytimer.start()
		is_waiting = true