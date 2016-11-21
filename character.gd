extends RigidBody2D

var object_moves = true
var idle_timer
var animation

func reset():
	set_mode(MODE_STATIC)
	randomize()
	set_pos(Vector2(rand_range(110,1000),-100))
	#set_pos(Vector2(400,3200))
	set_rot(rand_range(-0.5,0.5))
	show()

func _enter_tree():
	reset()

func _ready():
	idle_timer = get_node("/root/game/idle timer")
	animation = get_node("sprite/animation")

func _integrate_forces(state):
	var lv = get_linear_velocity()
	if abs(lv.x) < 16 && abs(lv.y) < 16 && abs(get_angular_velocity()) < 0.5:
		if object_moves:
			object_moves = false
			idle_timer.start()
	else:
		if !object_moves:
			object_moves = true
			idle_timer.stop()

func freeze():
	set_mode(MODE_STATIC)
	animation.stop_all()

func is_frozen():
	return (get_mode() == MODE_STATIC)

func run():
	set_mode(MODE_RIGID)
	set_sleeping(false)
	animation.play("rabbit")
