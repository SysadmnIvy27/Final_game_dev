extends Area2D

# standard code for all items
@export var item_name = "debug_target"
@export var texture : Texture2D
# faction alignment
@export var team = "enemy"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_hit():
	print(self.name + " hit!")
	queue_free()
