extends Area2D
signal hit

export var speed = 450
var screen_size

func _ready():
	hide()
	$Controls.hide()
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO
	$AnimatedSprite.play("default")
	
	if Input.is_action_pressed("move_left"):
		#velocity.x -= 1
		position.x = 193.0
		$AnimatedSprite.play("left")
	if Input.is_action_pressed("move_right"):
		#velocity.x += 1
		position.x = 398.0
		$AnimatedSprite.play("right")
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)


func _on_Player_body_entered(body):
	hide()
	$Controls.hide()
	emit_signal('hit')
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$Controls.show()
	$CollisionShape2D.disabled = false
