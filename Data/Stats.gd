extends Node

export(int) var maxHealth = 1
onready var health = maxHealth setget setHealth

signal no_health
signal no_stamina

func setHealth(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
