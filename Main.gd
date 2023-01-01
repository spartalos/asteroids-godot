extends Node

export(PackedScene) var asteroid_scene
export var numOfAsteroids = 6
export var numOfAsteroidBreaksWhenDestroyed = 2
export var addAsteroidOnScore = 3000
var asteroids: Array
var smallAsteroidsDestroyed = 0

var game_runs = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$HUD.show_message($HUD.getReadyMessage)
	
func startGame():
	$HUD.score = 0
	$Player.startPlayer()
	for i in numOfAsteroids:
		createAsteroidInstance()

func createAsteroidInstance():
	var instance = asteroid_scene.instance()
	asteroids.push_front(instance)
	add_child(instance)
	return instance

func breakAsteroid(startPosition, lastScale):
	for i in numOfAsteroidBreaksWhenDestroyed:
		var asteroid = createAsteroidInstance()
		asteroid.position = startPosition
		asteroid.scale = lastScale * 0.5
		
func gameOver():
	$Player.hide()
	$Player/CollisionShape2D.set_deferred("disabled", true)
	for asteroid in asteroids:
		asteroid.queue_free()
	asteroids = Array()
	$HUD.show_message($HUD.gameOverMessage)

func _on_Bullet_destroy(bullet: KinematicBody2D, asteroid: KinematicBody2D):
	if asteroid.scale.x > 1:
		breakAsteroid(bullet.position, asteroid.scale)
	else:
		smallAsteroidsDestroyed += 1
		if smallAsteroidsDestroyed % 4 == 0:
			createAsteroidInstance()
	$HUD.score += 100
	if $HUD.score % addAsteroidOnScore == 0:
		createAsteroidInstance()
	bullet.queue_free()
	asteroid.queue_free()
	asteroids.erase(asteroid)
	if (asteroids.size() == 0):
		gameOver()

func _on_HUD_message_hidden(message):
	startGame()

func _on_Player_hit():
	gameOver()
