extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
onready var timer = $Timer
var invincible = false setget setInvincible

signal invincibilityStarted
signal invincibilityEnded

func setInvincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibilityStarted")
	else:
		emit_signal("invincibilityEnded")

func createHitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	
func startInvincibility(duration):
	self.invincible = true
	timer.start(duration)


func _on_Timer_timeout():
	self.invincible = false
