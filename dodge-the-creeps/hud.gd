extends CanvasLayer
signal start_game(players)

func _ready() -> void:
	$SettingsPanel.hide()

func show_message(text):
	$Missatge.text = text
	$Missatge.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	await get_tree().create_timer(1).timeout
	show_menu()

func show_menu():
	$Missatge.text = "Dodge the\nCreeps!"
	$Missatge.show()
	$StartButton.show()
	$multiplayer.show()
	$setting.show()

func hide_menu():
	$Missatge.hide()
	$StartButton.hide()
	$multiplayer.hide()
	$setting.hide()

func update_score(score_1, score_2):
	$ScoreLabel.text = str(score_1)
	$ScoreLabel2.text = str(score_2)

func _on_StartButton_pressed():
	hide_menu()
	start_game.emit(1)

func _on_multiplayer_pressed():
	hide_menu()
	start_game.emit(2)

func _on_setting_pressed():
	hide_menu()
	$SettingsPanel.show()

func _on_back_button_pressed():
	$SettingsPanel.hide()
	show_menu()

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioServer.set_bus_mute(0, value == 0)

func _on_fullscreen_check_toggled(on):
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if on else DisplayServer.WINDOW_MODE_WINDOWED)

func _on_message_timer_timeout() -> void:
	$Missatge.hide()
