extends Node

# The variable "medialab_facade" enables a visualization mode for the digital
# facade of the Medialab-Prado building in Madrid. It is very specific and
# should be kept disabled in any other screen.
# http://medialab-prado.es/article/fachada_digital_informacion_tecnica
export var medialab_facade = false
var facade_offset = Vector2(40, 40)
var facade_size = Vector2(192, 157)

# Supported control methods are keyboard and network.
export var control_method = "keyboard"

var port = 29095
var packet_peer = PacketPeerUDP.new()

var rotation = 0
var initial_scene
var lives
var extra_actors = ["giraffe", "hippo", "parrot", "pig"]
var maps = []
var current_map = 0
var net_input_timer
var net_error_timer
var prev_jump_val1 = 1
var prev_jump_val2 = 1
var dead_zone = 0.2
var map_path = "map"
var camera_path = "map/camera"
var hud_path = "map/hud"
var map_container
var next_map_timer
var start_map_timer
var map_initialized = false

func _ready():
	next_map_timer = get_node("next map timer")
	start_map_timer = get_node("start map timer")

	if medialab_facade:
		OS.set_window_fullscreen(true)
		var container = get_node("container")
		container.set_pos(facade_offset)
		container.set_size(facade_size)
		camera_path = "container/viewport/map/camera"
		hud_path = "container/viewport/map/hud"
		map_path = "container/viewport/map"
		map_container = get_node("container/viewport")
	else:
		get_tree().set_screen_stretch(1, 1, Vector2(facade_size) * 4)
		map_container = get_node(".")

	initial_scene = load("res://init.tscn")
	maps.append(load("res://map01.tscn"))
	maps.append(load("res://map02.tscn"))
	maps.append(load("res://map03.tscn"))

	if control_method == "network":
		net_input_timer = get_node("network input timer")
		net_error_timer = get_node("network error timer")
		if packet_peer.listen(port) != OK:
			print("Network: Error listening on port ", port)

	set_process(true)
	map_container.add_child(initial_scene.instance())

func _process(delta):
	if control_method == "network":
		if packet_peer.is_listening():
			var num_packets = 0
			while packet_peer.get_available_packet_count() > 0:
				process_packet(packet_peer.get_packet())
				num_packets += 1
				if num_packets > 100:
					packet_peer.close()
					break
		else:
			if net_error_timer.get_time_left() == 0:
				net_error_timer.start()

func _on_network_error_timeout():
	packet_peer = PacketPeerUDP.new()
	if packet_peer.listen(port) != OK:
		print("Network: Error listening on port ", port)

func process_packet(packet):
	# This is not the OSC protocol but an ASCII packet resembling the OSC format,
	# which is much easier to handle within Godot.

	# print("DEBUG: packet received: ", packet.get_string_from_ascii())
	var fields = packet.get_string_from_ascii().split(" ", 0)
	if fields.size() < 2:
		return

	if not map_initialized:
		rotation = 0
		prev_jump_val1 = 1
		prev_jump_val2 = 1
		return

	var address = fields[0]
	if address == "/GameBlob": # Rotation
		if fields.size() != 6:
			return
		var type = fields[1]
		if type != "ffff":
			return
	
		var value = clamp((fields[2].to_float() - 0.5) * 2, -1, 1)
		if abs(value) > dead_zone:
			var new_rotation = 0
			if value > 0:
				new_rotation = (value - dead_zone) * 1.97
			else:
				new_rotation = (value + dead_zone) * 1.97
			if net_input_timer.get_time_left() == 0:
				rotation = new_rotation
				net_input_timer.start()
			else:
				rotation = (rotation + new_rotation) / 2
		else:
			rotation = 0

		get_node(camera_path).set_wanted_rotation(rotation)
	
	elif address == "/GameBlob2": # Jump
		if fields.size() != 6:
			return
		var type = fields[1]
		if type != "ffff":
			return

		var jump_val1 = clamp(fields[2].to_float(), 0, 1)
		var jump_val2 = clamp(fields[3].to_float(), 0, 1)
		if jump_val1 > prev_jump_val1 + 0.02 or jump_val2 > prev_jump_val2 + 0.02:
			get_node(map_path).get_node("character").jump(400, 0, false)
		prev_jump_val1 = jump_val1
		prev_jump_val2 = jump_val2

func get_control_method():
	return control_method

func start_game():
	lives = 3
	current_map = 0
	map_container.get_node("initial scene").queue_free()
	map_container.add_child(maps[current_map].instance())
	start_map_timer.start()

func reload_map():
	lives -= 1
	get_node(map_path).finish(false)
	next_map_timer.start()

func next_map():
	get_node(map_path).finish(true)
	current_map += 1
	current_map %= maps.size()
	next_map_timer.start()

func extra_life():
	lives += 1
	return extra_actors[int(rand_range(0, extra_actors.size() - 1))]

func _on_next_map_timeout():
	map_initialized = false
	var old_map = get_node(map_path)
	map_container.remove_child(old_map)
	old_map.free()
	if lives == 0: # End game
		map_container.add_child(initial_scene.instance())
	else:
		map_container.add_child(maps[current_map].instance())
		start_map_timer.start()

func _on_start_map_timeout():
	get_node(map_path).run()
