extends KinematicBody2D

var speed = 0
var velocity = Vector2.ZERO
var screen_size

export var MAX_SPEED = 200
var MIN_SPEED = MAX_SPEED * -1

var bullet = preload("res://Player/Bullet.tscn")

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func startPlayer():
	resetPlayerVectors()
	makeInvulnarable()
	show()
	
func makeInvulnarable():
	$InvisibilityTimer.start()
	$BlinkingTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	
func resetPlayerVectors():
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	velocity = Vector2.ZERO
	speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.UP.rotated(rotation)
	handleControls(delta)
	var collision_info = move_and_collide(velocity * speed * delta)
	if collision_info:
		hit(collision_info)
	resetAtOutOfBounds()
	$WeaponNode.look_at(position)

func handleControls(delta):
	if Input.is_action_pressed("move_up"):
		if speed <= MAX_SPEED:
			speed += 5
		$AnimatedSprite.animation = "full_thrust"
	if Input.is_action_pressed("move_down") && speed >= MIN_SPEED:
		speed -= 5
	if Input.is_action_pressed("move_left"):
		rotation -= PI * delta
	if Input.is_action_pressed("move_right"):
		rotation += PI * delta
	if Input.is_action_just_released("move_up"):
		$AnimatedSprite.animation = "no_thrust"
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.position = $WeaponNode/Position2D.global_position
	bullet_instance.rotation = $WeaponNode/Position2D.global_rotation
	bullet_instance.velocity = velocity
	bullet_instance.connect("destroy", get_parent() , "_on_Bullet_destroy")
	get_parent().add_child(bullet_instance)
		
func resetAtOutOfBounds():
	if position.x > screen_size.x:
		position.x = 0
	if position.y > screen_size.y:
		position.y = 0
	if position.x < 0:
		position.x = screen_size.x
	if position.y < 0:
		position.y = screen_size.y


func hit(collision):
	emit_signal("hit")


func _on_InvisibilityTimer_timeout():
	$BlinkingTimer.stop()
	show()
	$CollisionShape2D.set_deferred("disabled", false)


func _on_BlinkingTimer_timeout():
	if is_visible():
		hide()
	else:
		show()
