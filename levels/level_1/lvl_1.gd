extends Node2D
# access nodes
@onready var world_border = $world_boundry
@onready var respawn_point = $respawn



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for body in world_border.get_overlapping_bodies():
		body.global_position = respawn_point.global_position
	for area in world_border.get_overlapping_areas():
		area.global_position = respawn_point.global_position
