extends Node

var game

func _ready():
	game = get_node("/root/game")

func _on_timeout():
	game.start_game()
