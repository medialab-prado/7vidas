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
	

func _on_timeout():
	game.start_game()

func on_players_waiting():
	mytimer = get_node("Timer")
	var aux_time_left = mytimer.get_time_left()
	if aux_time_left < mytimer.get_wait_time() - 5:
		game.start_game()
		print("Restart Game")
	else:
		if not is_waiting:
			mytimer.stop()
			mytimer.set_wait_time(10)
			mytimer.start()
			print("Players Waiting")
		is_waiting = true