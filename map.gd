extends Area2D

var character
var camera
var camera_path = "/root/game/viewport/camera"

func _ready():
	character = get_node("character")
	camera = get_node(camera_path)
	camera.reset()

func freeze():
	camera.freeze()
	character.freeze()

func run():
	camera.run()
	character.run()

func reset():
	character.reset()
	camera.reset()
