extends RigidBody2D

# standard code for all items
@export var item_name = "debug_item"
@export var amount = 1
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
	if entity.has_method("add_item"): # for debugging only, eventually will be removed
		entity.add_item(self)
	if entity.has_node("inventory_manager"):
		entity.inv_manage.add_item(self)
		entity.inv_manager
