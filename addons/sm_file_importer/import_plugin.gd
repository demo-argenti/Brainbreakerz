@tool
extends EditorImportPlugin

func _get_importer_name():
	return "argenti.stepmania.file"

func _get_visible_name():
	return "StepMania File"

func _get_recognized_extensions():
	return ["sm"]
