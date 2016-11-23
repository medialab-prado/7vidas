extends CanvasLayer

var game
var key
var key_taken = false
var numbers
var numbers_anim
var initial_time_left
var time_left
var time_label
var current_map_name
var map_timer
var map_info1
var map_info2

func _ready():
	game = get_node("/root/game")
	key = get_node("key")
	numbers = get_node("numbers")
	numbers_anim = get_node("numbers/animation")
	time_label = get_node("time label")
	map_timer = get_node("map timer")
	map_info1 = get_node("map info 1")
	map_info2 = get_node("map info 2")
	key.hide()
	numbers.hide()
	set_process(true)

func _process(delta):
	var new_time_left = map_timer.get_time_left()
	if new_time_left > 0:
		if int(new_time_left) != time_left:
			time_left = int(new_time_left)
			time_label.set_text("%d:%02d" % [time_left/60, time_left%60])
		if time_left < 11:
			map_info2.set_text("Hurry up!")
			map_info2.show()

func reset(map_name, seconds):
	key_taken = false
	key.hide()
	numbers.hide()
	current_map_name = map_name
	map_info1.set_text(map_name)
	map_info1.show()
	map_info2.set_text("Ready!")
	map_info2.show()
	if seconds:
		time_left = int(seconds)
		initial_time_left = time_left
		time_label.set_text("%d:%02d" % [time_left/60, time_left%60])

func try_again():
	map_timer.stop()
	time_left = initial_time_left
	time_label.set_text("%d:%02d" % [time_left/60, time_left%60])
	map_info1.set_text(current_map_name)
	map_info1.show()
	map_info2.set_text("Try again")
	map_info2.show()

func enable_key():
	key_taken = true
	key.show()

func start_map():
	map_timer.set_wait_time(time_left)
	map_timer.start()
	map_info1.hide()
	map_info2.hide()

func idle_countdown_start():
	if map_timer.get_time_left() < numbers_anim.get_animation("idle countdown").get_length() + 5:
		return # Ignore idle when remaining map time is low
	numbers.show()
	numbers_anim.play("idle countdown")

func idle_countdown_stop():
	numbers_anim.stop_all()
	numbers.hide()

func _on_countdown_finished():
	map_info2.set_text("Move or die")
	map_info2.show()
	game.reload_map()

func _on_map_timeout():
	time_left = 0
	time_label.set_text("0:00")
	map_info1.set_text("Time's up")
	map_info1.show()
	game.reload_map()
