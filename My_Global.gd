extends Node

# グローバル変数の作成
var score = 0
var is_odango_finished : bool = true

enum game_state_type { Title, InGame, Result }

var game_state : game_state_type = game_state_type.Title
