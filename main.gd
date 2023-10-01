extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)
	MyGlobal.game_state = MyGlobal.game_state_type.Title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ゲームステートにより分岐
	if MyGlobal.game_state == MyGlobal.game_state_type.Title:
		# TODO: 上押したらスタート
		$HUD.show_message("                  PUSH\n                 [SPACE]")
		if MyGlobal.is_decide_key_just_pressed():
			new_game() # ゲーム開始処理
			MyGlobal.game_state = MyGlobal.game_state_type.InGame
	elif MyGlobal.game_state == MyGlobal.game_state_type.InGame:
		# TODO: UIを常に描画しているのは明らかに無駄。値の変化のシグナルを受け取って都度変更する構造に
		# できると動作が軽くできそう
		$HUD.update_score(MyGlobal.score)
		$HUD.update_remain("Remains: " + str(MyGlobal.remained_skewer))
	elif MyGlobal.game_state == MyGlobal.game_state_type.Result:
		game_over()
		if MyGlobal.is_decide_key_just_pressed():
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
	MyGlobal.remained_skewer = MyGlobal.remained_skewer_init_val
	MyGlobal.is_odango_finished = true
	MyGlobal.is_now_bonus_time = false
	MyGlobal.all_shotted_odango_kind.clear()
	$HUD.update_score(MyGlobal.score)
	$HUD.update_remain(MyGlobal.remained_skewer)
	$HUD.show_message("Shoot Dango")
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_mob_timer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

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
