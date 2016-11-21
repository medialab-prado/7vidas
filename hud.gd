extends CanvasLayer

var game
var key
var key_taken = false
var numbers
var numbers_anim

func _ready():
	game = get_node("/root/game")
	key = get_node("key")
	numbers = get_node("numbers")
	numbers_anim = get_node("numbers/animation")
	reset()

func reset():
	key_taken = false
	key.hide()

func enable_key():
	key_taken = true
	key.show()

func idle_countdown_start():
	numbers.show()
	numbers_anim.play("idle countdown")

func idle_countdown_stop():
	numbers_anim.stop_all()
	numbers.hide()

func _on_countdown_finished():
	game.reload_map()
