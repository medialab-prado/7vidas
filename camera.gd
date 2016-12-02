extends Camera2D

var frozen = false
var map_path = "/root/game/viewport/map"
var character_path = "/root/game/viewport/map/character"

func _ready():
	if get_node("/root/game").medialab_facade:
		set_zoom(Vector2(4,4))
	follow_character()
	set_process(true)

func reset():
	follow_character()
	run()

func follow_character():
	var character = get_node(character_path)
	set_pos(character.get_pos())

func freeze():
	frozen = true

func is_frozen():
	return frozen

func run():
	frozen = false

func _process(delta):
	if frozen:
		return
	follow_character()
	get_node(map_path).set_gravity_vector(Vector2(0,1).rotated(get_rot()))
