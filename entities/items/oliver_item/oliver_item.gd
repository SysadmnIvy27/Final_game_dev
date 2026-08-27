extends Area2D

var owner_entity : Node
@onready var movement_marker : Node
@onready var attack_range = $attack_area
@onready var timer = $Cooldown
@onready var tooltip = $tooltip
@export var projectile_scene : PackedScene
var has_owner = false
var SPEED = 100.0
var team
var cooldown = 1
var follow_dist = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_owner:
		var movement_direction = (movement_marker.global_position - global_position).normalized()
		var dist = sqrt((global_position.x - movement_marker.global_position.x) ** 2 + (global_position.y - movement_marker.global_position.y) ** 2)
		if dist > follow_dist:
			position += movement_direction * SPEED * delta
	if timer.is_stopped() and has_owner:
		for area in attack_range.get_overlapping_areas():
			if area.is_in_group("targetable") and area.team != team:
				shoot(area)
				timer.start(cooldown)
				break

func shoot(entity):
	var projectile = projectile_scene.instantiate() #instance projectile
	projectile.direction = (entity.global_position - global_position).normalized()
	projectile.team = team
	projectile.global_position = global_position
	get_tree().current_scene.add_child(projectile)
	

func interact(entity):
	if not has_owner:
		owner_entity = entity
		print("Recieved owner " + str(owner_entity.name))
		team = owner_entity.team
		movement_marker = entity.get_node("marker_oli")
		has_owner = true
		tooltip.visible = false
