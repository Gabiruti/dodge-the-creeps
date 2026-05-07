extends Node

@export var mob_scene: PackedScene
@export var star_buff_scene: PackedScene
var score
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	print("screen on main: ", screen_size.y)


func get_random_position() -> Vector2:
	var x = randf_range(10, screen_size.x)
	var y = randf_range(10, screen_size.y)
	return Vector2(x, y)

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$SpawnBuffTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("starbuffs", "queue_free")
	get_tree().call_group("mobs", "queue_free")
	
func handle_buff(_type: String):
	$Player.invulnerable = true
	$BuffTimer.start()
	

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$SpawnBuffTimer.start()

func _on_buff_timer_timeout() -> void:
	$Player.invulnerable = false
	$SpawnBuffTimer.start()
	print("FIM DO BUFF!")

func _on_spawn_buff_timer_timeout() -> void:
	var buff = star_buff_scene.instantiate()
	
	buff.position = get_random_position()
	buff.init_buff.connect(handle_buff)
	
	add_child(buff)
