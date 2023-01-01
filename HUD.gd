extends CanvasLayer

signal message_hidden

var message_visible = false

export var getReadyMessage = "Get Ready!"
export var gameOverMessage = "Game Over!"
var scoreLabel = "Score: %d"
var score = 0

func _process(delta):
	processScore()
	processMessage()
			
func processScore():
	$Score.text = scoreLabel % score
				
func processMessage():
	if message_visible:
		if $MessageAliveTimer.time_left == 0 && Input.is_action_just_pressed("shoot"):
			$Message.hide()
			get_tree().paused = false
			message_visible = false
			emit_signal("message_hidden", $Message.text)

func show_message(message):
	$Message.text = message
	$Message.show()
	message_visible = true
	get_tree().paused = true
	$MessageAliveTimer.start()
