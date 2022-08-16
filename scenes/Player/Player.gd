extends Area2D
signal hit

export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO
	$AnimatedSprite.play("default")
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite.play("left")
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite.play("right")
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)


func _on_Player_body_entered(body):
	hide()
	emit_signal('hit')
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
