extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 画面外に言ったらfreeして消えてもらう
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
