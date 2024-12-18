extends Node2D

var character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	character = $CharacterBody2D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save() -> Dictionary:
	print("save")
	# Save the game state
	var save_dict = {
		"transform.origin.x": character.transform.origin.x,
		"transform.origin.y": character.transform.origin.y,
		"idle_mode": character.idle_mode
	}
	return save_dict
