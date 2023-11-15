extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 250.0
const JUMP_VELOCITY = -200.0

enum Game_State { Idle, Walk }

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var game_state = Game_State.Idle

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		game_state = Game_State.Idle
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction != 0:
		game_state = Game_State.Walk
		animated_sprite_2d.flip_h = false if direction> 0 else true

	move_and_slide()
	
	if game_state == Game_State.Idle:
		animated_sprite_2d.play("default")
	elif game_state == Game_State.Walk:
		animated_sprite_2d.play("walk")

