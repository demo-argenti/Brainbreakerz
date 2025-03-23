extends Control

var score : int = 0

var thousands : int = 0

var lives : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.increment_score.connect(_on_increment_score)
	Global.increment_life.connect(_on_increment_life)
	Global.lose_life.connect(_on_lose_life)
	Global.level_score = 0
	Global.level_lives = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(Global.level_score) + " pts"
	$CanvasLayer/LivesLabel.text = str(Global.level_lives) + " lives"

func _on_increment_score(precision):
	if precision == 1:
		Global.level_score += 300
	elif precision == 2:
		Global.level_score += 200
	elif precision == 3:
		Global.level_score += 100
	elif precision == 4:
		Global.level_score += 50
	update_thousands()


func _on_increment_life():
	gain_life()
	
func _on_lose_life():
	lose_life()


func gain_life():
	Global.level_lives += 1

func lose_life():
	Global.level_lives -= 1
	if Global.level_lives == 0:
		Global.out_of_lives.emit()


func update_thousands():
	if Global.level_score / 10000 > thousands:
		gain_life()
		thousands += 1
	elif Global.level_score / 10000 < thousands:
		thousands -= 1
