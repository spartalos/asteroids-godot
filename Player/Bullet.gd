extends KinematicBody2D

signal destroy

export var bullet_speed = 400
var velocity = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$FreeBulletTimer.start()

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * bullet_speed)
	if collision_info:
		if "Asteroid" in collision_info.collider.name:
			emit_signal("destroy", self, collision_info.collider)

func _on_FreeBulletTimer_timeout():
	queue_free()
