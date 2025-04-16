extends Control

const level_folder_parth = "res://Levels/"

@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_levels()

func fill_levels() -> void:
	var level_paths = DirAccess.get_files_at(level_folder_parth)
	print(level_paths)
	for level_path in level_paths:
		var button = Button.new()
		button.text = level_path.replace(".tscn", "").to_upper().replace("_", " ")
		v_box_container.add_child(button)
		button.set_custom_minimum_size(Vector2(0,50))

		
		button.pressed.connect(func():
			$Transition.fade_out()
			get_tree().change_scene_to_file(level_folder_parth + level_path)
			)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://objects/Main_Menu.tscn")
	pass # Replace with function body.
