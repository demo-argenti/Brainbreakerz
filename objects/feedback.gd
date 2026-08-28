extends Node2D
const HitScore = Global.HitScore

func play_animation(hit_value: int):
	match hit_value:
		HitScore.PERFECT:
			$AnimationPlayer.play("Perfect_Fade")
		HitScore.GREAT:
			$AnimationPlayer.play("Great_Fade")
		HitScore.GOOD:
			$AnimationPlayer.play("Good_Fade")
		HitScore.NOT_HIT:
			$AnimationPlayer.play("Miss_Fade")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
