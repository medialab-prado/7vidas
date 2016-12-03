extends Area2D

export var map_name = "Scene 1"
export var time_limit = 45

var character
var camera
var hud

func _ready():
	hud = get_node("hud")
	character = get_node("character")
	camera = get_node("camera")
	camera.reset()
	hud.reset(map_name, time_limit, true)
	if not get_node("/root/game"):
		run()

func run():
	character.run()
	hud.start_map()

func finish(completed):
	character.freeze()
	hud.end_map(completed)

func reset():
	character.reset()
	camera.reset()
	hud.reset(map_name, time_limit, false)

func _on_body_enter_fatality(body):
	if body.get_name() != "character":
		return
	character.explode()

func _on_body_enter_water(body):
	if body.get_name() != "character":
		return
	character.drown()

func _on_body_enter_lava(body):
	if body.get_name() != "character":
		return
	character.burn()
