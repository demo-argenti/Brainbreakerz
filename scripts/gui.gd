extends Control

var score : int = 0

var thousands : int = 0

var lives : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.increment_score.connect(_on_increment_score)
	Global.increment_life.connect(_on_increment_life)
	Global.lose_life.connect(_on_lose_life)
	score = 0
	lives = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(score) + " pts"
	$CanvasLayer/LivesLabel.text = str(lives) + " lives"

func _on_increment_score(precision):
	if precision == 1:
		score += 300
	elif precision == 2:
		score += 200
	elif precision == 3:
		score += 100
	elif precision == 4:
		score += 50
	update_thousands()


func _on_increment_life():
	gain_life()
	
func _on_lose_life():
	lose_life()


func gain_life():
	lives += 1

func lose_life():
	lives -= 1


func update_thousands():
	if score / 10000 > thousands:
		gain_life()
		thousands += 1
	elif score / 10000 < thousands:
		thousands -= 1
