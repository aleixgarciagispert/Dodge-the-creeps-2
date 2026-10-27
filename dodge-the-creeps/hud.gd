extends CanvasLayer
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show_message(text):
	$Missatge.text = text
	$Missatge.show()
	$MessageTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_game_over():
	show_message("Game Over")
	# Espereu fins que el MessageTimer hagi acabat de comptar.
	await $MessageTimer.timeout
	$Missatge.text = "Dodge the\nCreeps!"
	$Missatge.show()
	# Feu un temporitzador one-shot i espereu que acabi.
	await get_tree().create_timer(1).timeout
	$StartButton.show()
	$StartButton_text.show()
	
func update_score(score_1, score_2):
	$ScoreLabel.text = str(score_1)
	$ScoreLabel2.text = str(score_2)

func _on_StartButton_pressed():
	$StartButton.hide()
	$Missatge.hide()
	$StartButton.hide()
	$StartButton_text.hide()
	emit_signal("start_game")

func _on_message_timer_timeout() -> void:
	$Missatge.hide() # Replace with function body.
