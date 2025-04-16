extends Node

const save_location = "user://SaveFile.json"

var contents_to_save : Dictionary = {
		"tutorial_high_score" : 0,
		"level_1_high_score" : 0,
		"level_2_high_score" : 0,
		"level_3_high_score" : 0
	}

func _ready():
	_load()
	
func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.tutorial_high_score = save_data.tutorial_high_score 
		contents_to_save.level_1_high_score = save_data.level_1_high_score
		contents_to_save.level_2_high_score = save_data.level_2_high_score 
		contents_to_save.level_3_high_score = save_data.level_3_high_score 
		

func save_current_level_high_score(level_num : int, high_score : int):
	match level_num:
		0:
			contents_to_save.tutorial_high_score = high_score
		1:
			contents_to_save.level_1_high_score = high_score
		2:
			contents_to_save.level_2_high_score = high_score
		3:
			contents_to_save.level_3_high_score = high_score

func get_current_level_high_score(level_num : int):
	match level_num:
		0:
			return contents_to_save.tutorial_high_score
		1:
			return contents_to_save.level_1_high_score
		2:
			return contents_to_save.level_2_high_score
		3:
			return contents_to_save.level_3_high_score
