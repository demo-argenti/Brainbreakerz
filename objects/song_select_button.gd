class_name SongSelectButton extends Button


@export var song: SongDef:
	set(value):
		song = value
		text = song.song_title
@export var chart_idx : int = 0


func _ready() -> void: pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Global.queued_song = song
	Global.queued_chart_idx = chart_idx
	
	Transition.transition("res://Levels/ingame_scene.tscn",true)

func _process(delta: float) -> void: pass
