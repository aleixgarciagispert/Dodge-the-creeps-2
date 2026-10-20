extends Node
@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # Replace with function body.
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func game_over() :
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
# Replace with function body.
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	#$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")



func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start() # Replace with function body.


func _on_score_timer_timeout() :
	score += 1
	$HUD.update_score(score)

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
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
# Va fer que la multitud s'afegís a l'escena principal.
	add_child(mob)
	print(mob)
