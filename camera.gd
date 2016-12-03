extends Camera2D

var frozen = false
var game
var map
var character
var wanted_rotation = 0

func _enter_tree():
	game = get_node("/root/game")
	if game and game.medialab_facade:
		set_zoom(Vector2(4,4))

func _ready():
	game = get_node("/root/game")
	map = get_parent()
	character = map.get_node("character")
	reset()

func reset():
	follow_character()
	run()

func follow_character():
	set_pos(character.get_pos())

func freeze():
	set_process(false)
	frozen = true

func is_frozen():
	return frozen

func run():
	set_process(true)
	frozen = false

func set_wanted_rotation(rotation):
	wanted_rotation = rotation

func _process(delta):
	if frozen:
		return
	follow_character()
	map.set_gravity_vector(Vector2(0,1).rotated(get_rot()))

	if not game or game.get_control_method() == "keyboard":
		if Input.is_action_pressed("rotate_cw"):
			wanted_rotation = 1.5708
		elif Input.is_action_pressed("rotate_ccw"):
			wanted_rotation = -1.5708
		else:
			wanted_rotation = 0

	var camera_rotation = get_rot()
	if camera_rotation > wanted_rotation:
		var rotation_speed = max(0.5, (camera_rotation - wanted_rotation) * 2)
		camera_rotation -= rotation_speed * delta
		if camera_rotation < wanted_rotation:
			camera_rotation = wanted_rotation
	elif camera_rotation < wanted_rotation:
		var rotation_speed = max(0.5, (wanted_rotation - camera_rotation) * 2)
		camera_rotation += rotation_speed * delta
		if camera_rotation > wanted_rotation:
			camera_rotation = wanted_rotation
	camera_rotation = clamp(camera_rotation, -1.5708, 1.5708)
	set_rot(camera_rotation)
