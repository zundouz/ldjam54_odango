extends Label
var is_already_blinked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 101 # 障子より前
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 引数でRGB受け取れるようしたけど、点滅は決め打ちの方が見た目カッコよかったのでRGBを関数内で使ってない
func apply_ui_blink(red: float, green: float, blue: float):
	if is_already_blinked == true:
		return
		
	is_already_blinked = true
	
	# tweenの作成
	var tween = get_tree().create_tween()
	
	# 1秒かけて透明にする
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.1).set_trans(Tween.TRANS_CUBIC)
	
	# 1秒かけて不透明にする
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.1).set_trans(Tween.TRANS_CUBIC)
	
	# アニメーションを繰り返す設定
	tween.set_loops()
