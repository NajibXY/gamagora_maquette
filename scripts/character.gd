extends CharacterBody2D


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0
const SPEED = 140.0
const JUMP_VELOCITY = -10.0

var animated_body: AnimatedSprite2D
var collision_node: CollisionShape2D

var menu_node

enum IdleModes {
	RIGHT = 0,
	UP = 1,
	LEFT = 2,
	DOWN = 3
}

var idle_mode := IdleModes.RIGHT

func _ready() -> void:
	menu_node = $"/root/Game/CanvasLayer/Menu"
	# Hide menu_node 
	menu_node.hide()
	animated_body = get_node("AnimatedSprite")
	collision_node = get_node("CollisionShape2D")
	animated_body.play("idle_down")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	# Menu input
	if Input.is_action_just_pressed("escape"):
		if menu_node.is_visible():
			menu_node.hide()
		else:
			menu_node.show()

	if menu_node.is_visible():
		return

	# Handle movement input
	handle_movement_input()

	# move_and_slide()

func handle_movement_input() -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * SPEED

	if velocity.x > 0:
		print("right")
		animated_body.play("walk_right")
		idle_mode = IdleModes.RIGHT
	elif velocity.x < 0:
		animated_body.play("walk_left")
		idle_mode = IdleModes.LEFT
	elif velocity.y < 0:
		animated_body.play("walk_up")
		idle_mode = IdleModes.UP
	elif velocity.y > 0:
		animated_body.play("walk_down")
		idle_mode = IdleModes.DOWN
	
	if velocity.x == 0 and velocity.y == 0:
		change_idle_animation()
	
	move_and_slide()
	

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
	
	




	
	
