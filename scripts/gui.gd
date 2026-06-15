extends Control

# TODO this partially handles scoring/judgement and Global partially handles it
# Move judgement/scoring logic into its own class maybe

var score : int = 0
var thousands : int = 0
var lives : int


func _ready() -> void:
	Global.increment_score.connect(_on_increment_score)
	Global.increment_life.connect(_increment_life)
	Global.lose_life.connect(_lose_life)
	Global.level_score = 0
	Global.level_lives = 5
	if Calibration.has_instance: $CanvasLayer/ScoreLabel.hide()


func _process(_delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(Global.level_score) + " pts"
	$CanvasLayer/LivesLabel.text = str(Global.level_lives) + " lives"

const HitScore = Global.HitScore
func _on_increment_score(precision:Global.HitScore) -> void:
	match precision:
		HitScore.PERFECT:   Global.level_score += 500
		HitScore.GREAT:     Global.level_score += 250
		HitScore.GOOD:      Global.level_score += 100
		HitScore.HOLD_TICK: Global.level_score += 50
		_: push_warning("tried to increment score based on unknown hit value %d!" % [ precision ])
	update_thousands()


func _increment_life() -> void: Global.level_lives += 1

func _lose_life() -> void:
	Global.level_lives -= 1
	if Global.level_lives == 0: Global.out_of_lives.emit()


func update_thousands() -> void:
	if Global.level_score / 10000 > thousands:
		_increment_life()
		thousands += 1
	elif Global.level_score / 10000 < thousands:
		thousands -= 1
