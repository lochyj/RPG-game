extends Node

export(int) var maxHealth = 1
export(int) var maxStamina = 1
onready var health = maxHealth setget setHealth
onready var stamina = maxStamina setget setStamina

signal no_health
signal no_stamina

func setHealth(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
		
func setStamina(value):
	stamina = value
	if stamina <= 0:
		emit_signal("no_stamina")
