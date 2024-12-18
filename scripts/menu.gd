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
	pass

func _on_quit_button_pressed():
	## TODO Save the game state
	get_tree().quit()

func _on_return_button_pressed():
	print("hide")
	hide()
