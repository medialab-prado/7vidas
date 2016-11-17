extends CanvasLayer

var key
var key_taken = false

func _ready():
	key = get_node("key")
	reset()

func reset():
	key_taken = false
	key.hide()

func enable_key():
	key_taken = true
	key.show()
