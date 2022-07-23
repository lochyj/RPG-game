extends Node

export(int) var maxHealth = 1 setget setMaxHealth
var health = maxHealth setget setHealth

signal no_health
signal health_changed(value)
signal max_health_changed(value)
# signal no_stamina

func setMaxHealth(value):
	maxHealth = value
	if health != null:
		self.health = min(health, maxHealth)
	else:
		self.health = maxHealth
	emit_signal("max_health_changed", maxHealth)

func setHealth(value):
	health = value
	emit_signal("health_changed", health)
	# Death / no health signal
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = maxHealth
