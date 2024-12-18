extends Control

@onready var game_node = $"root/Game"
@onready var canvas = $"root/Game/CanvasLayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var quit_button : Button = $PanelContainer/VBoxContainer/HBoxContainer2/QuitButton
	var return_button : Button  = $PanelContainer/VBoxContainer/HBoxContainer/ReturnButton

	print(quit_button)
	print(return_button)
	quit_button.pressed.connect(_on_quit_button_pressed)
	return_button.pressed.connect(_on_return_button_pressed)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if is_visible():
			hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			show()
	pass

func _on_quit_button_pressed():
	## TODO Save the game state
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	hide()
	save_game()
	get_tree().quit()

func _on_return_button_pressed():
	print("hide")
	get_tree().paused = false
	hide()

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	print(save_nodes)
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
