extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

enum { idle, run, jump, fall }
@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var currentAnim: int = idle
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	print(direction)
	if direction:
		velocity.x = direction * SPEED
		currentAnim = run
		if direction < 0:
			animSprite.flip_h = true
		else:
			animSprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			currentAnim = fall
		else:
			currentAnim = jump

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var dicAnim = {0: "idle", 1: "run", 2: "jump", 3: "fall"}
	animSprite.play(dicAnim[currentAnim])

	move_and_slide()
