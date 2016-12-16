extends Node

var game

func _ready():
	game = get_node("/root/game")
	if game and game.medialab_facade:
		set_scale(Vector2(0.25, 0.25))

func _on_timeout():
	game.start_game()
