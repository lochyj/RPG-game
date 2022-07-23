extends KinematicBody2D


# -------
# Exports
# -------
export(int) var FRICTION = 400
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 200
export(int) var PUSH_VALUE = 400
export(int) var WANDER_RANGE = 4

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
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController


func _ready():
	state = pickRandState([IDLE, WANDER])
	# Randomises the bat animation so they arent in sync
	sprite.frame = rand_range(0, 4)

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

	if softCollision.isColliding():
		velocity += softCollision.getPushVector() * delta * PUSH_VALUE
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
	timeOut()

func Wander(delta):
	seekPlayer()
	timeOut()
	var direction = setDirection(wanderController.targetPos)
	setVelocity(direction, delta)

	if global_position.distance_to(wanderController.targetPos) <= WANDER_RANGE:
		state = pickRandState([IDLE, WANDER])
		wanderController.startTimer(rand_range(1, 3))
	sprite.flip_h = velocity.x < 0

func Chase(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = setDirection(player.global_position)
		setVelocity(direction, delta)
	else:
		state = IDLE
	sprite.flip_h = velocity.x < 0

# ---------------
# Other functions
# ---------------
func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = CHASE

func timeOut():
	if wanderController.getTimeLeft() == 0:
		state = pickRandState([IDLE, WANDER])
		wanderController.startTimer(rand_range(1, 3))

func setVelocity(direction, delta):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func setDirection(dir):
	return global_position.direction_to(dir)

func pickRandState(stateList):
	stateList.shuffle()
	return stateList.pop_front()
