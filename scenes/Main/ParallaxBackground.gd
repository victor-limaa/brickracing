extends ParallaxBackground

export var speed = 100

func _ready():
	pass

func _process(delta):
	scroll_base_offset += Vector2(0, speed) * delta
