extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# TODO: タイトルだけ点滅、それ以外は点滅せずというのを実現したい…
#	# tweenの作成
#	var tween = get_tree().create_tween()
#
#	# 1秒かけて透明にする
#	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.25).set_trans(Tween.TRANS_CUBIC)
#
#	# 1秒かけて不透明にする
#	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.25).set_trans(Tween.TRANS_CUBIC)
#
#	# アニメーションを繰り返す設定
#	tween.set_loops()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	if MyGlobal.game_state != MyGlobal.game_state_type.InGame:
#		var tween = get_tree().create_tween()
#		tween.stop()
