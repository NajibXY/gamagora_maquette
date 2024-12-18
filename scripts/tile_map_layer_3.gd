extends TileMapLayer

var menu_node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_node = $"/root/Game/CanvasLayer/Menu"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if menu_node.is_visible():
		get_tree().paused = true
	else :
		get_tree().paused = false
	pass
