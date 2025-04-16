extends AnimatedSprite2D

func _ready():
	visible = false

func transition(scene : String):
	play()
	get_tree().change_scene_to_file(scene)
	play_backwards()

func fade_out():
	visible = true
	play()
	
	
func fade_in():
	visible = true
	play_backwards()
	visible = false
