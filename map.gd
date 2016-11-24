extends Area2D

export var map_name = "Scene 1"
export var time_limit = 45

var character
var camera
var camera_path = "/root/game/viewport/camera"
var hud
var hud_path = "/root/game/hud"

func _ready():
	character = get_node("character")
	camera = get_node(camera_path)
	camera.reset()
	hud = get_node(hud_path)
	hud.reset(map_name, time_limit, true)

func run():
	camera.run()
	character.run()
	hud.start_map()

func finish():
	camera.freeze()
	character.freeze()
	hud.end_map()

func reset():
	character.reset()
	camera.reset()
	hud.reset(map_name, time_limit, false)
