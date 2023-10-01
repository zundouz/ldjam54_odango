extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	z_index = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MyGlobal.game_state == MyGlobal.game_state_type.Result:
		position.x = 160
	else:
		position.x = 128
