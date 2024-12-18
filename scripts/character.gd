extends CharacterBody2D


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0
const SPEED = 140.0
const JUMP_VELOCITY = -10.0

var animated_body: AnimatedSprite2D
var player_node: Node2D
var collision_node: CollisionShape2D


enum IdleModes {
	RIGHT = 0,
	UP = 1,
	LEFT = 2,
	DOWN = 3
}

var idle_mode := IdleModes.RIGHT

func _ready() -> void:
	print($PlayerNode)
	animated_body = $PlayerNode.get_node("CharacterCreatorToolImporter").get_node("AnimatedSprite")
	collision_node = get_node("CollisionShape2D")
	player_node = get_node("PlayerNode")
	animated_body.play("idle_down")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	# Handle movement input

	handle_movement_input()
	handle_velocity()

	# move_and_slide()

func handle_movement_input() -> void:
	if Input.is_action_pressed("right"):
		animated_body.play("walk_right")
		idle_mode = IdleModes.RIGHT
	elif Input.is_action_pressed("left"):
		animated_body.play("walk_left")
		idle_mode = IdleModes.LEFT
	elif Input.is_action_pressed("up"):
		animated_body.play("walk_up")
		idle_mode = IdleModes.UP
	elif Input.is_action_pressed("down"):
		animated_body.play("walk_down")
		idle_mode = IdleModes.DOWN
	else:
		change_idle_animation()
	

func change_idle_animation() -> void:
	match idle_mode:
		IdleModes.RIGHT:
			animated_body.play("idle_right")
		IdleModes.LEFT:
			animated_body.play("idle_left")
		IdleModes.UP:
			animated_body.play("idle_up")
		IdleModes.DOWN:
			animated_body.play("idle_down")

func handle_velocity() -> void:
	var direction := Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = direction * SPEED
	var direction_y := Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity.y = direction_y * SPEED
	
	move_and_slide()

	handle_positions()

func handle_positions() -> void:

	# todo refactor this to a better handling
	collision_node.transform.origin = Vector2(transform.origin.x, transform.origin.y + 5)
	player_node.transform.origin = transform.origin
	print(transform.origin)
	print("Collision pos " , collision_node.transform.origin)
	print("Player pos " , player_node.transform.origin)
	animated_body.transform.origin = transform.origin
	
	
