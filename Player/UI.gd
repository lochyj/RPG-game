extends Control

var hearts = 5 setget setHearts
var maxHearts = 5 setget setMaxHearts

onready var label = $Label

func setHearts(value):
	hearts = clamp(value, 0, maxHearts)
	if label != null:
		label.text = str(hearts)+ "/" + str(maxHearts)

func setMaxHearts(value):
	maxHearts = max(value, 1)

func _ready():
	self.maxHearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "setHearts")
