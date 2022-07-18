extends KinematicBody2D

var knockback = Vector2.ZERO
const FRICTION = 200
onready var stats = $Stats

func _ready():
	print(stats.maxHealth)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150


func _on_Stats_no_health():
	queue_free()
