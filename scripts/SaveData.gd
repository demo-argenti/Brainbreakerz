extends Resource
class_name SaveDataResource

@export var tutorial_high_score : int = 0
@export var tutorial_finished : bool = false
@export var level_one_high_score : int = 0
@export var level_one_finished : bool = false
@export var level_two_high_score : int = 0
@export var level_two_finished : bool = false
@export var level_three_high_score : int = 0
@export var level_three_finished : bool = false
@export var bonus_level_high_score : int = 0
@export var bonus_level_finished : bool = false


func get_level_high_score(level : int) -> int:
	match level:
		Global.tutorial:
			return tutorial_high_score
		Global.level_1:
			return level_one_high_score
		Global.level_2:
			return  level_two_high_score
		Global.level_3:
			return level_three_high_score
		Global.bonus_level:
			return bonus_level_high_score
		_:
			return 0
			
	
func set_level_high_score(level : int, score : int) -> void:
	match level:
		Global.tutorial:
			tutorial_high_score = score
		Global.level_1:
			level_one_high_score = score
		Global.level_2:
			level_two_high_score = score
		Global.level_3:
			level_three_high_score = score
		Global.bonus_level:
			bonus_level_high_score = score
	
func get_level_finished(level : int) -> bool:
	match level:
		Global.tutorial:
			return tutorial_finished
		Global.level_1:
			return level_one_finished
		Global.level_2:
			return  level_two_finished
		Global.level_3:
			return level_three_finished
		Global.bonus_level:
			return bonus_level_finished
		_:
			return false
	
func set_level_finished(level : int, is_finished : bool) -> void:
	match level:
		Global.tutorial:
			tutorial_finished = is_finished
		Global.level_1:
			level_one_finished = is_finished
		Global.level_2:
			level_two_finished = is_finished
		Global.level_3:
			level_three_finished = is_finished
		Global.bonus_level:
			bonus_level_finished = is_finished
