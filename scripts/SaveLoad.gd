extends Node

const SAVE_LOCATION = "user://SaveFile.tres"

var SaveFileData : SaveDataResource = null

func _ready() -> void:
	if ResourceLoader.exists(SAVE_LOCATION):
		SaveFileData = ResourceLoader.load(SAVE_LOCATION, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		SaveFileData = SaveDataResource.new()

func _save() -> void:
	ResourceSaver.save(SaveFileData, SAVE_LOCATION)
	
func _load() -> void:
	if(FileAccess.file_exists(SAVE_LOCATION)):
		SaveFileData = ResourceLoader.load(SAVE_LOCATION).duplicate(true)
