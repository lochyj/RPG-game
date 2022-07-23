extends KinematicBody2D

# ---------------
# Movement consts
# ---------------
export(int) var MAX_SPEED = 80
export(int) var ACCELERATION = 450
export(int) var FRICTION = 900
export(float) var ROLL_MULTIPLIER = 1.5

# ---------------
# State enum type
# ---------------
enum {
	MOVE,
	ROLL,
	ATTACK
}

# -------------------------
# State, velocity and other
# -------------------------
var state = MOVE
var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
var stats = PlayerStats

# ------------------------
# Onready vars / Animation
# ------------------------
onready var animationPlayer =  $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $HurtBox
onready var swordHitbox = $HitboxPivot/SwordHitbox

# ------------------------------------------------------------------
# _ready():
# 	Ensures that the animationTree is active when the player is loaded
# ------------------------------------------------------------------
func _ready():
	stats.connect("no_health", self, "reset")
	animationTree.active = true
	swordHitbox.knockback_vector = rollVector

# -------------------------------------------------------------------------------------------------
# Uses _physics_process because we access the move_and_slide() method within a subsequent function,
# which requires a post physics process delta
# -------------------------------------------------------------------------------------------------
func _physics_process(delta):
#func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

# -------------------
# Animation functions
# -------------------
func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	# Evasion script
	hurtbox.set_collision_layer_bit(2, true)
	# ---
	state = MOVE
	velocity = velocity / 2

# -------------
# State machine
# -------------
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		rollVector = input_vector
		swordHitbox.knockback_vector = input_vector
		# ------------------------------------------------------------
		# Setting the animation blend positions for the animation tree
		# ------------------------------------------------------------
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")

	move()

	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state(_delta):
	# Evasion script
	hurtbox.set_collision_layer_bit(2, false)
	# ---
	velocity = rollVector * MAX_SPEED * ROLL_MULTIPLIER
	animationState.travel("Roll")
	move()

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func reset():
	queue_free()

func _on_HurtBox_area_entered(_area):
	stats.health -= 1
	hurtbox.startInvincibility(0.5)
	hurtbox.createHitEffect()
