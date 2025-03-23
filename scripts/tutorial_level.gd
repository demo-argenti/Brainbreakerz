extends Node2D

func _ready():
	Global.out_of_lives.connect(_on_out_of_lives)

func _on_conductor_finished():
	get_tree().change_scene_to_file("res://objects/victory_screen.tscn")

func _on_out_of_lives():
	get_tree().change_scene_to_file("res://objects/loss_screen.tscn")
