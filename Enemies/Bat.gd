extends KinematicBody2D


# -------
# Exports
# -------
export(int) var FRICTION = 400
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 200

# --------
# Preloads
# --------
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

# -------------
# Gameplay bars
# -------------
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

# -------------------------
# Accessing the object tree
# -------------------------
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $HurtBox

# ---------------
# Physics process
# ---------------
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			Idle(delta)
		WANDER:
			Wander(delta) # nothing here yet
		CHASE:
			Chase(delta)
			
	velocity = move_and_slide(velocity)
	
# -----------
# Connections
# -----------

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.createHitEffect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
# -----------------------
# State machine functions
# -----------------------
func Idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seekPlayer()

func Wander(delta):
	pass

func Chase(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE
	sprite.flip_h = velocity.x < 0

# ---------------
# Other functions
# ---------------
func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = CHASE
