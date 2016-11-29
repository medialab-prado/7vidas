extends AnimatedSprite

export var force = 500

var jumping = false
var spring_timer

func _ready():
	spring_timer = get_node("spring timer")

func _on_body_enter(body):
	if jumping or body.get_name() != "character":
		return
	body.jump(force)
	jumping = true
	set_frame(1)
	spring_timer.start()

func _on_spring_timeout():
	set_frame(0)
	jumping = false
