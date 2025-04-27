extends Control


func _ready():
	$AnimationPlayer.play("MindBlown")
	
	pass


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "MindBlown"):
		$AnimationPlayer.play("Headphones")
	else:
		get_tree().change_scene_to_file("res://objects/Main_Menu.tscn")
