extends Node2D

export(int) var wanderRange = 32

onready var startPos = global_position
onready var targetPos = global_position
onready var timer = $Timer

func updateTargetPos():
	var targetVector = Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange, wanderRange))
	targetPos = startPos + targetVector

func _on_Timer_timeout():
	updateTargetPos()

func startTimer(duration):
	timer.start(duration)

func getTimeLeft():
	return timer.time_left
