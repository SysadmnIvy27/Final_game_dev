#extends Area2D
extends CharacterBody2D

var owner_entity : Node
var movement_marker : Node
@onready var attack_range = $attack_area
@onready var interact_range = $interact_area
@onready var detection_range = $detection_range
@onready var timer = $Cooldown
@onready var tooltip = $tooltip
@onready var camera = $Camera2D
@export var projectile_scene : PackedScene
var has_owner = false
var can_teleport = false
var debug = false
var SPEED = 100.0
var team
var cooldown = 1
var follow_dist = 75
var teleport_dist = 500
var move_target : Node
var modes = ["Sentry","AI","Player Control"]
var mode = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if has_owner:
		if modes[mode - 1] == "Sentry":
			Sentry_mode()
		elif modes[mode - 1] == "AI":
			AI_mode()
		elif modes[mode - 1] == "Player Control":
			Player_Ctrl()
		
func Sentry_mode():
	attack()

func AI_mode():
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
	
	if dist > follow_dist and dist < teleport_dist and move_target == movement_marker: # follow logic
		velocity = movement_direction * SPEED
	elif dist > teleport_dist and can_teleport: # teleportation logic
		global_position = movement_marker.global_position
	elif move_target != movement_marker:
		velocity = movement_direction * SPEED
	else:
		if velocity.x > 1.4:
			velocity.x -= 1
		elif velocity.x < -1.4:
			velocity.x += 1
		elif velocity.x < 1.5 and velocity.x > -1.5:
			velocity.x = 0
		
		if velocity.y > 4.8:
			velocity.y -= 1
		elif velocity.y < -4.8:
			velocity.y += 1
		elif velocity.y < 8.5 and velocity.y > -8.5:
			velocity.y = 0
		
		if debug:
			print(str(velocity))
			
	move_and_slide()
	
	attack()
	interaction()
	
func Player_Ctrl():
	var direction : Vector2
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	interaction()
	
func attack():
	# attack logic
	if timer.is_stopped() and has_owner:
		for area in attack_range.get_overlapping_areas():
			if area.is_in_group("targetable") and (area.team != "neutral" and area.team != team):
				shoot(area)
				timer.start(cooldown)
				break

func interaction():
	# interact logic
	for area in interact_range.get_overlapping_areas():
		if area.is_in_group("interactable") and (area != owner_entity and area != self):
			area.interact(self)
	for body in interact_range.get_overlapping_bodies():
		if body.is_in_group("interactable") and (body != owner_entity and body != self):
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
