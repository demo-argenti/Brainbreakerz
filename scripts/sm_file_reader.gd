extends Node

@export var filename : String

var file

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_file():
	if FileAccess.file_exists(filename):
		file = FileAccess.open(filename, FileAccess.READ)
	else:
		pass


func read_file():
	pass
