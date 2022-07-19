extends KinematicBody2D


# --------------------
# Exports and preloads
# --------------------
export(int) var FRICTION = 400
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 200
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

# --------------------
# State machine things
# --------------------
var state = IDLE

enum {
	IDLE,
	WANDER,
	CHASE
}

# ----------
# Other vars
# ----------
var velocity = Vector2.ZERO
onready var stats = $Stats
var knockback = Vector2.ZERO
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite

# ----------
# Start body
# ----------
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seekPlayer()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	velocity = move_and_slide(velocity)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150

func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = CHASE

# -----------------------
# State machine functions
# -----------------------
func Idle(delta):
	pass

func Wander(delta):
	pass

func Chase(delta):
	pass

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
