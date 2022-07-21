extends Node

export(int) var maxHealth = 1
onready var health = maxHealth setget setHealth

signal no_health
signal health_changed(value)
# signal no_stamina

func setHealth(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
