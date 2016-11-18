extends RigidBody2D

var object_moves = true
var idle_timer

func _ready():
	idle_timer = get_node("/root/game/idle timer")
	randomize()
	set_pos(Vector2(rand_range(110,1000),-100))
	set_rot(rand_range(-0.5,0.5))

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
