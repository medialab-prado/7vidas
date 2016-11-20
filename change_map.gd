extends CanvasLayer

var timer1
var timer2
var next_map = null
var gameview_path = "/root/game/viewport"
var map_path = "/root/game/viewport/map"
var hud_path = "/root/game/hud"

func _ready():
	timer1 = get_node("timer1")
	timer2 = get_node("timer2")

func start():
	timer2.start()

func next(map):
	next_map = map
	get_node(map_path).freeze()
	timer1.start()

func reload():
	next(null)

func _on_timeout_1():
	if next_map:
		var old_map = get_node(map_path)
		get_node(gameview_path).remove_child(old_map)
		old_map.free()
		var new_map = next_map.instance()
		get_node(gameview_path).add_child(new_map)
		get_node(hud_path).reset()
	else:
		get_node(map_path).reset()
	timer2.start()

func _on_timeout_2():
	get_node(map_path).run()
	queue_free()
