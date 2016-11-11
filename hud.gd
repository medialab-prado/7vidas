extends CanvasLayer

var keys = []

func _ready():
	keys.append(get_node("blue key"))
	keys.append(get_node("green key"))
	keys.append(get_node("red key"))
	keys.append(get_node("yellow key"))

func reset():
	for key in keys:
		key.set_frame(0)

func enable_key(idx):
	keys[idx].set_frame(1)
