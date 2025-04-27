extends Node2D

func play_animation(hit_value: int):
	match hit_value:
		Global.PERFECT:
			$AnimationPlayer.play("Perfect_Fade")
		Global.GREAT:
			$AnimationPlayer.play("Great_Fade")
		Global.GOOD:
			$AnimationPlayer.play("Good_Fade")
		Global.NOT_HIT:
			$AnimationPlayer.play("Miss_Fade")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
