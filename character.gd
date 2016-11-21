extends RigidBody2D

var object_moves = true
var animation
var hud

func reset():
	set_mode(MODE_STATIC)
	randomize()
	set_pos(Vector2(rand_range(110,1000),-100))
	#set_pos(Vector2(400,3200))
	set_rot(rand_range(-0.5,0.5))

func _enter_tree():
	reset()

func _ready():
	animation = get_node("sprite/animation")
	hud = get_node("/root/game/hud")

func _integrate_forces(state):
	var lv = get_linear_velocity()
	if abs(lv.x) < 16 && abs(lv.y) < 16 && abs(get_angular_velocity()) < 0.5:
		if object_moves:
			object_moves = false
			hud.idle_countdown_start()
	else:
		if !object_moves:
			object_moves = true
			hud.idle_countdown_stop()

func freeze():
	set_mode(MODE_STATIC)
	animation.stop_all()

func is_frozen():
	return (get_mode() == MODE_STATIC)

func run():
	set_mode(MODE_RIGID)
	set_sleeping(false)
	animation.play("rabbit")
