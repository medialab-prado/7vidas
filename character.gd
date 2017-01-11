extends RigidBody2D

var object_moves = true
var game
var hud
var animation
var reload_map_timer
var jump_timer
var do_jump = false
var jump_force
var jump_angle
var do_explode = false
var frag
var actor = "rabbit"
var actor_names = ["rabbit", "snake", "panda", "giraffe", "hippo", "parrot", "pig"]

func reset():
	set_mode(MODE_STATIC)
	randomize()
	set_pos(Vector2(rand_range(110,1000),-100))
	set_rot(rand_range(-0.5,0.5))
	do_jump = false
	do_explode = false
	show()

func change_actor(new_actor):
	actor = new_actor
	animation.set_current_animation(actor)
	animation.seek(0, true)

func _ready():
	game = get_node("/root/game")
	hud = get_node("../hud")
	animation = get_node("sprite/animation")
	reload_map_timer = get_node("reload map timer")
	jump_timer = get_node("jump timer")
	frag = load("res://frag.tscn")
	reset()

func _process(delta):
	if not game or game.get_control_method() == "keyboard":
		if Input.is_action_pressed("jump"):
			jump(200, 0, false)

func _integrate_forces(state):
	var lv = get_linear_velocity()

	if do_explode:
		freeze()
		hide()
		var num_frags = 20
		for i in range(0, num_frags):
			var f = frag.instance()
			f.get_node("sprites").set_frame(actor_names.find(actor))
			f.set_pos(get_pos() + Vector2(rand_range(-32,32),rand_range(-32,32)))
			PS2D.body_add_collision_exception(f.get_rid(), get_rid())
			get_parent().add_child(f)
			f.apply_impulse(Vector2(0,0), Vector2(1,0).rotated(deg2rad(180*i/(num_frags-1)))*500)
		do_explode = false
		return

	if do_jump:
		var impulse = Vector2(0,1).rotated(jump_angle)
		if abs(impulse.x) > abs(impulse.y) + 0.4:
			set_linear_velocity(Vector2(0, lv.y))
		elif abs(impulse.y) > abs(impulse.x) + 0.4:
			set_linear_velocity(Vector2(lv.x, 0))
		else:
			set_linear_velocity(Vector2(0,0))
		apply_impulse(Vector2(0,0), -jump_force * impulse)
		do_jump = false
		return

	if abs(lv.x) < 16 && abs(lv.y) < 16 && abs(get_angular_velocity()) < 0.5:
		if object_moves:
			object_moves = false
			hud.idle_countdown_start()
	else:
		if !object_moves:
			object_moves = true
			hud.idle_countdown_stop()

func freeze():
	set_process(false)
	set_mode(MODE_STATIC)
	animation.stop()

func is_frozen():
	return (get_mode() == MODE_STATIC)

func run():
	set_process(true)
	set_mode(MODE_RIGID)
	set_sleeping(false)
	animation.play(actor)

func jump(force = 500, angle = 0, external_force = true):
	if external_force:
		set_pos(get_pos() + Vector2(0, -20).rotated(angle))
	else:
		if jump_timer.get_time_left() != 0:
			return
		jump_timer.start()
	jump_force = force
	jump_angle = angle
	do_jump = true

func explode():
	do_explode = true
	hud.end_map(false)
	hud.show_hint("Fatality")
	reload_map_timer.start()

func burn():
	freeze()
	set_rot(0)
	get_node("burn").set_emitting(true)
	hud.end_map(false)
	hud.show_hint("Ouch!")
	reload_map_timer.start()

func drown():
	freeze()
	set_rot(0)
	get_node("drown").set_emitting(true)
	hud.end_map(false)
	hud.show_hint("Glub glub glub")
	reload_map_timer.start()

func _on_reload_map_timeout():
	if game:
		game.reload_map()
