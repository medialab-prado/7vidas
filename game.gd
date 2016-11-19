extends Container

# The variable "medialab_facade" enables a visualization mode for the digital
# facade of the Medialab-Prado building in Madrid. It is very specific and
# should be kept disabled in any other screen.
# http://medialab-prado.es/article/fachada_digital_informacion_tecnica

export var medialab_facade = false

var port = 29095
var packet_peer = PacketPeerUDP.new()

var rotation = 0
var maps = []
var current_map = 0
var keyboard = false
var net_input_timer
var dead_zone = 0.2
var camera_node

func _ready():
	if medialab_facade:
		var offset = Vector2(40, 40)
		OS.set_window_fullscreen(true)
		set_pos(offset)
		set_size(Vector2(192,157))
		get_node("hud").set_scale(Vector2(0.25, 0.25))
		get_node("hud").set_offset(offset)
	else:
		set_size(OS.get_window_size())
		get_node("/root").connect("size_changed", self, "new_window_size")

	maps.append(load("res://map01.tscn"))
	#maps.append(load("res://map02.scn"))

	net_input_timer = get_node("network input timer")
	if packet_peer.listen(port) != OK:
		print("Network: Error listening on port ", port)

	camera_node = get_node("viewport/camera")
	set_process(true)

func new_window_size():
	set_size(get_node("/root").get_rect().size)
	var scaleX = get_node("/root").get_rect().size.x / 768
	var scaleY = get_node("/root").get_rect().size.y / 628
	get_node("hud").set_scale(Vector2(scaleX, scaleY))

func _process(delta):
	if packet_peer.is_listening():
		while packet_peer.get_available_packet_count() > 0:
			process_packet(packet_peer.get_packet())

	if Input.is_action_pressed("rotate_cw"):
		keyboard = true
		rotation = 1.5708
	elif Input.is_action_pressed("rotate_ccw"):
		keyboard = true
		rotation = -1.5708
	elif keyboard:
		rotation = 0

	var camera_rotation = camera_node.get_rot()
	if camera_rotation > rotation:
		var rotation_speed = (camera_rotation - rotation) * 2
		if rotation_speed < 0.5:
			rotation_speed = 0.5
		camera_rotation -= rotation_speed * delta
		if camera_rotation < rotation:
			camera_rotation = rotation
	elif camera_rotation < rotation:
		var rotation_speed = (rotation - camera_rotation) * 2
		if rotation_speed < 0.5:
			rotation_speed = 0.5
		camera_rotation += rotation_speed * delta
		if camera_rotation > rotation:
			camera_rotation = rotation
	camera_rotation = clamp(camera_rotation, -1.5708, 1.5708)
	camera_node.set_rot(camera_rotation)

func process_packet(packet):
	# This is not the OSC protocol but an ASCII packet resembling the OSC format,
	# which is much easier to handle within Godot.
	
	# print("DEBUG: packet received: ", packet.get_string_from_ascii())
	var fields = packet.get_string_from_ascii().split(" ", 0)
	if fields.size() != 6:
		return

	var address = fields[0]
	if address != "/GameBlob":
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

func _on_idle_timeout():
	call_deferred("_deferred_change_map")

func _on_map_exit_timeout():
	call_deferred("_deferred_change_map")

func _deferred_change_map():
	var old_map = get_node("viewport/map")
	remove_child(old_map)
	old_map.free()
	current_map += 1
	current_map %= maps.size()
	var new_map = maps[current_map].instance()
	get_node("viewport").add_child(new_map)

	get_node("/root/game/hud").reset()
