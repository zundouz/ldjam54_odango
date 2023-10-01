extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var is_missing_shot = false
var missing_shot_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MyGlobal.is_odango_finished == false:
		$AnimatedSprite2D.set_animation("shot")
	elif MyGlobal.is_odango_finished == true:
		if is_missing_shot == false:
			$AnimatedSprite2D.set_animation("default")
		if (MyGlobal.is_decide_key_just_pressed() 
			and MyGlobal.remained_skewer < MyGlobal.remained_skewer_init_val - 1
			and MyGlobal.remained_skewer > 0
			):
			$SeSwing.play()
			is_missing_shot = true
			$AnimatedSprite2D.set_animation("shot")
		
		if MyGlobal.game_state != MyGlobal.game_state_type.InGame:
			return # リザルト→タイトルに戻れなくなるバグの対策
		# ついでに、ここで串の現象判定をする
		if MyGlobal.remained_skewer <= 0 and MyGlobal.game_state != MyGlobal.game_state_type.Title:
			MyGlobal.game_state = MyGlobal.game_state_type.Result
		if MyGlobal.is_decide_key_just_pressed():
			MyGlobal.remained_skewer -= 1	
	if is_missing_shot == true:
		$AnimatedSprite2D.set_animation("shot")
		missing_shot_counter = missing_shot_counter + 1
		if missing_shot_counter > 30:
			missing_shot_counter = 0
			is_missing_shot = false
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
