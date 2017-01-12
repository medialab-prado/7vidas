extends Node

var game
var animJump
var animMove
var animInsert

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
