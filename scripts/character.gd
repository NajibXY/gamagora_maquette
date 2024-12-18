extends CharacterBody2D


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0
const SPEED = 140.0
const JUMP_VELOCITY = -10.0

var animated_body: AnimatedSprite2D
var collision_node: CollisionShape2D
var map_node: Node2D

var menu_node

enum IdleModes {
	RIGHT = 0,
	UP = 1,
	LEFT = 2,
	DOWN = 3
}

var idle_mode := IdleModes.RIGHT

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	menu_node = $"/root/Game/CanvasLayer/Menu"
	# Hide menu_node 
	menu_node.hide()
	animated_body = get_node("AnimatedSprite")
	collision_node = get_node("CollisionShape2D")
	map_node = get_node("/root/Game/Map")

	menu_node.process_mode = Node.PROCESS_MODE_ALWAYS

	animated_body.play("idle_down")

	load_game()
	

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
			get_tree().paused = false
		else:
			get_tree().paused = true
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

func load_game() -> void:
	print("load")
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		print("line")
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			elif i == "idle_mode":
				idle_mode = node_data[i]
				change_idle_animation()
			elif i == "transform.origin.x":
				transform.origin.x = node_data[i]
			elif i == "transform.origin.y":
				transform.origin.y = node_data[i]
			else:
				print("Unknown key: ", i)			
			
			
