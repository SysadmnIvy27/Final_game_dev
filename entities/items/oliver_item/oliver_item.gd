extends Area2D

var owner_entity : Node
var movement_marker : Node
@onready var attack_range = $attack_area
@onready var interact_range = $interact_area
@onready var detection_range = $detection_range
@onready var timer = $Cooldown
@onready var tooltip = $tooltip
@export var projectile_scene : PackedScene
var has_owner = false
var can_teleport = false
var debug = false
var SPEED = 100.0
var team
var cooldown = 1
var follow_dist = 20
var teleport_dist = 500
var move_target : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_owner:
		# gettitng targets
		var targets : Array
		for area in detection_range.get_overlapping_areas():
			if area.is_in_group("targetable"):
				targets.append(area)
				if debug:
					print(area.name + " area")
		for body in detection_range.get_overlapping_bodies():
			if body.is_in_group("targetable"):
				targets.append(body)
				if debug:
					print(body.name + " body")
		
		var closest_target : Node
		var target_dist : float
		closest_target = null
		target_dist = 1000
		for target in targets:
			if target.is_in_group("interactable"):
				if global_position.distance_to(target.global_position) < target_dist:
					closest_target = target
					target_dist = global_position.distance_to(target.global_position)
		move_target = closest_target
		can_teleport = false
		if closest_target != null and debug:
			print("The closest target is: " + closest_target.name + " " + str(target_dist))
		
		if debug:
			print("List Start:")
			for target in targets:
				print(target.name + " distance: " + str(global_position.distance_to(target.global_position)))
		
		if move_target == null:
			move_target = movement_marker
			can_teleport = true
		
		var movement_direction = (move_target.global_position - global_position).normalized()
		
		var dist = global_position.distance_to(move_target.global_position)
		
		if dist > follow_dist and dist < teleport_dist: # follow logic
			position += movement_direction * SPEED * delta
		elif dist > teleport_dist and can_teleport: # teleportation logic
			global_position = movement_marker.global_position
	
	# attack logic
	if timer.is_stopped() and has_owner:
		for area in attack_range.get_overlapping_areas():
			if area.is_in_group("targetable") and (area.team != team or area.team != "neutral"):
				shoot(area)
				timer.start(cooldown)
				break
				
	# interact logic
	for area in interact_range.get_overlapping_areas():
		if area.is_in_group("interactable") and (area != owner_entity or area != self):
			area.interact(self)
	for body in interact_range.get_overlapping_bodies():
		if body.is_in_group("interactable") and (body != owner_entity or body != self):
			body.interact(self)

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
		owner_entity.drone = self
		movement_marker = entity.get_node("marker_oli")
		print(movement_marker.name)
		has_owner = true
		tooltip.visible = false
