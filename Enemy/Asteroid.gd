extends KinematicBody2D

export var scaleSize = 2
export var numOfBreaksRemaining = 3
var screen_size
var velocity

const MIN_SPEED = 25.0
const MAX_SPEED = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	setStartPosition()

	var direction = rotation + PI / 2 + rand_range(-PI, PI)
	rotation = direction
	velocity = Vector2(rand_range(MIN_SPEED, MAX_SPEED), 0.0).rotated(direction)

func setStartPosition():
	screen_size = get_viewport_rect().size
	position.x = rand_range(0, screen_size.x / 10)
	position.y = rand_range(0, screen_size.y / 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	resetAtOutOfBounds()
	position += velocity * delta

func resetAtOutOfBounds():
	if position.x > screen_size.x:
		position.x = 0
	if position.y > screen_size.y:
		position.y = 0
	if position.x < 0:
		position.x = screen_size.x
	if position.y < 0:
		position.y = screen_size.y
