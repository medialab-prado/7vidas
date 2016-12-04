extends CanvasLayer

# Timer can change scene

var game
var key
var key_taken = false
var hint_active = false
var next_hint = null
var hint_timer
var numbers
var numbers_anim
var gems_info_anim
var time_left
var time_label
var current_map_name
var map_timer
var map_info1
var map_info2
var door_is_opening = false

func _enter_tree():
	game = get_node("/root/game")
	if game and game.medialab_facade:
		set_scale(Vector2(0.25, 0.25))

func _ready():
	game = get_node("/root/game")
	key = get_node("key")
	numbers = get_node("numbers")
	numbers_anim = get_node("numbers/animation")
	gems_info_anim = get_node("gems info/animation")
	time_label = get_node("time label")
	map_timer = get_node("map timer")
	map_info1 = get_node("map info 1")
	map_info2 = get_node("map info 2")
	hint_timer = get_node("hint timer")
	key.hide()
	numbers.hide()
	set_process(true)

func _process(delta):
	var new_time_left = map_timer.get_time_left()
	if new_time_left > 0:
		if int(new_time_left) != time_left:
			time_left = int(new_time_left)
			time_label.set_text("%d:%02d" % [time_left/60, time_left%60])
			if time_left == 9 or time_left == 7:
				show_hint("Hurry Up!")

func pixel_perfect(label):
	# This ugly code makes the label text start on exact pixel boundaries on
	# medialab facade. As resolution is quite low, it makes a big difference.
	if not game or not game.medialab_facade:
		return
	label.set_align(0)
	var font = label.get_font("font")
	var size = font.get_string_size(label.get_text())
	var offset = ((768 - int(size.x)) / 2)
	offset -= offset % 4
	var pos = label.get_pos()
	pos.x = offset
	label.set_pos(pos)

func reset(map_name, seconds, first_try = true):
	stop_hints()
	current_map_name = map_name
	map_info1.set_text(map_name)
	pixel_perfect(map_info1)
	map_info1.show()
	if first_try:
		key_taken = false
		key.hide()
		numbers.hide()
		map_info2.set_text("Ready!")
	else:
		map_info2.set_text("Try again")
	pixel_perfect(map_info2)
	map_info2.show()
	time_left = int(seconds)
	time_label.set_text("%d:%02d" % [time_left/60, time_left%60])

func enable_key():
	key_taken = true
	key.show()

func is_key_taken():
	return key_taken

func show_hint(message):
	if time_left < 2:
		return
	if hint_active:
		if next_hint:
			return
		next_hint = message
		return
	map_info2.set_text(message)
	pixel_perfect(map_info2)
	map_info2.show()
	hint_active = true
	hint_timer.start()

func stop_hints():
	next_hint = null
	hint_timer.stop()
	hint_active = false

func _on_hint_timeout():
	map_info2.hide()
	hint_active = false
	if next_hint:
		var message = next_hint
		next_hint = null
		show_hint(message)

func time_bonus(seconds):
	var new_time = map_timer.get_time_left() + seconds
	map_timer.stop()
	map_timer.set_wait_time(new_time)
	map_timer.start()
	if seconds == 20:
		gems_info_anim.queue("rise 20")
	elif seconds == 5:
		gems_info_anim.queue("rise 5")

func start_map():
	map_timer.set_wait_time(time_left)
	map_timer.start()
	map_info1.hide()
	map_info2.hide()

func end_map(completed):
	gems_info_anim.clear_queue()
	idle_countdown_stop()
	map_timer.stop()
	if completed:
		map_info1.set_text("Well done")
		pixel_perfect(map_info1)
		map_info1.show()
		map_info2.hide()

func door_opening(enabled):
	if not enabled and map_timer.get_time_left() == 0:
		map_timeout()
	door_is_opening = enabled

func idle_countdown_start():
	if map_timer.get_time_left() < numbers_anim.get_animation("idle countdown").get_length() + 5:
		return # Ignore idle when remaining map time is low
	numbers.show()
	numbers_anim.play("idle countdown")

func idle_countdown_stop():
	numbers_anim.stop()
	numbers.hide()

func _on_countdown_finished():
	stop_hints()
	map_info2.set_text("Keep moving")
	pixel_perfect(map_info2)
	map_info2.show()
	game.reload_map()

func map_timeout():
	gems_info_anim.clear_queue()
	stop_hints()
	time_left = 0
	time_label.set_text("0:00")
	map_info1.set_text("Time's up")
	pixel_perfect(map_info1)
	map_info1.show()
	game.reload_map()

func _on_map_timeout():
	if get_node("/root/game/viewport/map").getCurrentMapName() == "Escena Inicial":
		game.next_map()
	if not door_is_opening:
		map_timeout()
