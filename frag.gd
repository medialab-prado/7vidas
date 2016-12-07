extends RigidBody2D

func _ready():
	var timer = get_node("timer")
	timer.set_wait_time(rand_range(4.0, 8.0))
	timer.start()

func _on_timeout():
	get_node("sprites/anim").play("disappear")

func _on_anim_finished():
	queue_free()
