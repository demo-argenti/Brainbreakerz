extends Node2D

func _ready():
	$Control/CanvasLayer/Score.text = str(Global.level_score) + " pts"
