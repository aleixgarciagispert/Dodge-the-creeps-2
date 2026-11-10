extends CanvasLayer
signal start_game(players)

const SETTINGS_PATH = "user://settings.cfg"

var difficulty = 1 # 0 = fàcil, 1 = normal, 2 = difícil
var zen = false

func _ready() -> void:
	$SettingsPanel.hide()
	load_settings()

func load_settings():
	var cfg = ConfigFile.new()
	cfg.load(SETTINGS_PATH) # Si no existeix, es fan servir els valors per defecte.
	var volume = cfg.get_value("audio", "volume", 1.0)
	var muted = cfg.get_value("audio", "muted", false)
	var fullscreen = cfg.get_value("video", "fullscreen", false)
	difficulty = cfg.get_value("game", "difficulty", 1)
	zen = cfg.get_value("game", "zen", false)
	$SettingsPanel/DifficultyOption.select(difficulty)
	$SettingsPanel/ZenCheck.set_pressed_no_signal(zen)
	# Actualitza els controls sense disparar els senyals (no cal guardar encara).
	$SettingsPanel/VolumeSlider.set_value_no_signal(volume)
	$SettingsPanel/MuteCheck.set_pressed_no_signal(muted)
	$SettingsPanel/FullscreenCheck.set_pressed_no_signal(fullscreen)
	apply_volume(volume)
	AudioServer.set_bus_mute(0, muted)
	apply_fullscreen(fullscreen)

func save_settings():
	var cfg = ConfigFile.new()
	cfg.set_value("audio", "volume", $SettingsPanel/VolumeSlider.value)
	cfg.set_value("audio", "muted", $SettingsPanel/MuteCheck.button_pressed)
	cfg.set_value("video", "fullscreen", $SettingsPanel/FullscreenCheck.button_pressed)
	cfg.set_value("game", "difficulty", difficulty)
	cfg.set_value("game", "zen", zen)
	cfg.save(SETTINGS_PATH)

func apply_volume(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func apply_fullscreen(on):
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if on else DisplayServer.WINDOW_MODE_WINDOWED)

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
	apply_volume(value) # En temps real mentre s'arrossega.
	save_settings()

func _on_mute_check_toggled(on):
	AudioServer.set_bus_mute(0, on)
	save_settings()

func _on_difficulty_option_item_selected(index):
	difficulty = index
	save_settings()

func _on_zen_check_toggled(on):
	zen = on
	save_settings()

func _on_fullscreen_check_toggled(on):
	apply_fullscreen(on)
	save_settings()

func _on_message_timer_timeout() -> void:
	$Missatge.hide()
