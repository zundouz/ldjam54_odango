extends Node

@export var mob_scene: PackedScene



# Called when the node enters the scene tree for the first time.
func _ready():
	MyGlobal.game_state = MyGlobal.game_state_type.Title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(MyGlobal.game_state)
	# ゲームステートにより分岐
	if MyGlobal.game_state == MyGlobal.game_state_type.Title:
		# TODO: 上押したらスタート
		$HUD.show_message("                  PUSH\n                 [SPACE]")
		if Input.is_action_just_pressed("space"):
			new_game() # ゲーム開始処理
			MyGlobal.game_state = MyGlobal.game_state_type.InGame
	elif MyGlobal.game_state == MyGlobal.game_state_type.InGame:
		$HUD.update_score(MyGlobal.score)
		print(MyGlobal.remained_skewer)
	elif MyGlobal.game_state == MyGlobal.game_state_type.Result:
		game_over()
		if Input.is_action_just_pressed("space"):
			# タイトルに戻るループ
			MyGlobal.game_state = MyGlobal.game_state_type.Title
	else:
		print("不正")

func game_over():
	# $ScoreTimer.stop()
	$HUD.show_game_over()
	$MobTimer.stop()
	$StartTimer.stop()


func new_game():
	MyGlobal.score = 0
	MyGlobal.remained_skewer = 11
	MyGlobal.is_odango_finished = true
	$HUD.update_score(MyGlobal.score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_mob_timer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	# 別に左右に振る理由もないので今のままでいいのでは…
#	if mob_spawn_location.progress_ratio >= 0 and mob_spawn_location.progress_ratio < 0.25:
#		mob_spawn_location.progress_ratio += 0.25

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	# direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 300.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_start_timer_timeout():
	$MobTimer.start()
