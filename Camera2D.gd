extends Camera2D

var shake_duration = 0.0
var shake_intensity = 5.0
var original_position = Vector2()

func _ready():
	original_position = position
	print(is_current)

func shake_camera(duration, intensity):
	shake_duration = duration
	shake_intensity = intensity
	set_process(true)

func _process(delta):
	if shake_duration > 0:
		position = original_position + Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_duration -= delta
	else:
		position = original_position
		set_process(false)
