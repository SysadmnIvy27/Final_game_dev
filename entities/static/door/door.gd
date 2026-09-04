extends StaticBody2D

@onready var door_collision = $CollisionShape2D
var doors : Array
var ID = name
var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child.is_in_group("Door"):
			doors.append(child)
			child.bound_door = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if open == true:
		door_collision.disabled = true
	else:
		door_collision.disabled = false
