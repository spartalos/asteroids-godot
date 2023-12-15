extends CharacterBody2D

signal destroy

@export var bullet_speed = 400
var vel = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$FreeBulletTimer.start()

func _physics_process(delta):
	var collision_info = move_and_collide(vel.normalized() * delta * bullet_speed)
	if collision_info:
		var collider = collision_info.get_collider()
		var colliderGroups = collider.get_groups()
		if "asteroids" in colliderGroups:
			emit_signal("destroy", self, collider)

func _on_FreeBulletTimer_timeout():
	queue_free()
