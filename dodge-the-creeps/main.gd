extends Node
@export var mob_scene: PackedScene
var score_1 = 0
var score_2 = 0
var alive_1 = false
var alive_2 = false
const START_POS_1 = Vector2(192, 368)
const START_POS_2 = Vector2(304, 488)
# Per dificultat (fàcil, normal, difícil): temps entre creeps i multiplicador de velocitat.
const MOB_WAIT = [0.8, 0.5, 0.3]
const MOB_SPEED = [0.75, 1.0, 1.3]
var zen = false
var playing = false
var speed_mult = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Player.hit.connect(_on_player_hit)
	$Player_2.hit.connect(_on_player_hit)


func _on_player_hit(player):
	if player == $Player:
		alive_1 = false
	else:
		alive_2 = false
	# Només acaba el joc quan moren els dos.
	if not alive_1 and not alive_2:
		game_over()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _unhandled_input(event):
	# Al mode Zen no hi ha game over: Esc torna al menú.
	if playing and zen and event.is_action_pressed("ui_cancel"):
		playing = false
		$ScoreTimer.stop()
		$MobTimer.stop()
		$StartTimer.stop()
		$Music.stop()
		get_tree().call_group("mobs", "queue_free")
		$Player.hide()
		$Player_2.hide()
		$HUD.show_menu()


func game_over() :
	playing = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathMusic.play()
# Replace with function body.
func new_game(num_players):
	$DeathMusic.stop()
	playing = true
	zen = $HUD.zen
	var level = $HUD.difficulty
	$MobTimer.wait_time = MOB_WAIT[level]
	speed_mult = MOB_SPEED[level]
	score_1 = 0
	score_2 = 0
	alive_1 = true
	alive_2 = num_players == 2
	$Player.invincible = zen
	$Player_2.invincible = zen
	$HUD.update_score(score_1, score_2)
	$HUD/ScoreLabel.visible = not zen
	$HUD/ScoreLabel2.visible = alive_2 and not zen
	$HUD.show_message("Zen (Esc per sortir)" if zen else "Get Ready")
	$Player.start(START_POS_1)
	if alive_2:
		$Player_2.start(START_POS_2)
	else:
		$Player_2.hide()
		$Player_2/CollisionShape2D.set_deferred("disabled", true)
	$StartTimer.start()
	$Music.play()
	get_tree().call_group("mobs", "queue_free")



func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start() # Replace with function body.


func _on_score_timer_timeout() :
	if zen: # Mode Zen: sense puntuació.
		return
	# Només suma al jugador que segueix viu.
	if alive_1:
		score_1 += 1
	if alive_2:
		score_2 += 1
	$HUD.update_score(score_1, score_2)

 # Replace with function body.




func _on_mob_timer_timeout():
	
# Crea una nova instància de l'escena Mob.
	var mob = mob_scene.instantiate()
# Trieu una ubicació aleatòria a Path2D.
	var mob_spawn_location:PathFollow2D = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
# Estableix la direcció de la multitud perpendicular a la direcció del camí.
	var direction = mob_spawn_location.rotation + PI / 2
# Estableix la posició de la multitud a una ubicació aleatòria.
	mob.position = mob_spawn_location.position
# Afegeix una mica d'aleatorietat a la direcció.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
# Tria la velocitat de la multitud.
	var velocity = Vector2(randf_range(150.0,250.0) * speed_mult,0.0)
	mob.linear_velocity = velocity.rotated(direction)
# Va fer que la multitud s'afegís a l'escena principal.
	add_child(mob)
	print(mob)
