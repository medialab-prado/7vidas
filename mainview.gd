extends Container

# The variable "medialab_facade" enables a visualization mode for the digital
# facade of the Medialab-Prado building in Madrid. It is very specific and
# should be kept disabled in any other screen.
# http://medialab-prado.es/article/fachada_digital_informacion_tecnica

export var medialab_facade = false

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

func new_window_size():
	set_size(get_node("/root").get_rect().size)
	var scaleX = get_node("/root").get_rect().size.x / 768
	var scaleY = get_node("/root").get_rect().size.y / 628
	get_node("hud").set_scale(Vector2(scaleX, scaleY))
