extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	# TODO: あとで串アニメーションの処理のために入力処理を復活させる
	if MyGlobal.is_odango_finished == false:
		$AnimatedSprite2D.set_animation("shot")
	elif MyGlobal.is_odango_finished == true:
		$AnimatedSprite2D.set_animation("default")
		
		if MyGlobal.game_state != MyGlobal.game_state_type.InGame:
			return # リザルト→タイトルに戻れなくなるバグの対策
		# ついでに、ここで串の現象判定をする
		if MyGlobal.remained_skewer <= 0:
			MyGlobal.game_state = MyGlobal.game_state_type.Result
		if MyGlobal.is_decide_key_just_pressed():
			MyGlobal.remained_skewer -= 1
	


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
