extends Control

var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.increment_score.connect(_on_increment_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(score) + " pts"

func _on_increment_score(precision):
	if precision == 1:
		score += 300
	elif precision == 2:
		score += 200
	elif precision == 3:
		score += 100
