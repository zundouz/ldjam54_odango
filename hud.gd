extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$RemainLabel.show()
	$MessageTimer.start()	

func show_game_over():
	show_message("We are closed for business today.")
	await $MessageTimer.timeout
	# $Message.text = "Odango"
	$Message.show()
	# $RemainLabel.hide()
	await get_tree().create_timer(1).timeout
#	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_remain(remainAmount):
	$RemainLabel.text = str(remainAmount)

func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
