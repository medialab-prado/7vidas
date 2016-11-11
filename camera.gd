extends Camera2D

func _ready():
	if get_tree().get_root().get_node("game").medialab_facade:
		set_zoom(Vector2(4,4))
	set_process(true)

func _process(delta):
	var character = get_node("../map/character")
	set_pos(character.get_pos())
	get_node("../map").set_gravity_vector(Vector2(0,1).rotated(get_rot()))
