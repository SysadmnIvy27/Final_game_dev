extends RigidBody2D

# standard code for all items
@export var item_name = "debug_item"
@export var texture : Texture2D
# faction alignment
@export var team = "neutral"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact(entity):
	print(self.name + " picked up by " + entity.name)
	queue_free()
