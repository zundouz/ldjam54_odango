extends Node

# グローバル変数の作成
var score : int = 0
var remained_skewer : int = 11
var is_odango_finished : bool = true

enum game_state_type { Title, InGame, Result }

var game_state : game_state_type = game_state_type.Title
