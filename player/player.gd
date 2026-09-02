extends CharacterBody2D

@onready var interaction_range = $interaction_range
@onready var camera = $Camera2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var team = "friendly"
var lock_movement = false
var drone : Node

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		for area in interaction_range.get_overlapping_areas():
			if area.is_in_group("interactable"):
				print("interacting with " + area.name)
				area.interact(self)
				break
		for body in interaction_range.get_overlapping_bodies():
			if body.is_in_group("interactable"):
				print("interacting with " + body.name)
				body.interact(self)
				break
	# swapping drone logic
	if Input.is_action_just_pressed("swap_drone_action") and drone != null:
		if drone.mode < len(drone.modes):
			drone.mode += 1
		else:
			drone.mode = 1
			
		if drone.mode == 3:
			camera.enabled = false
			drone.camera.enabled = true
			lock_movement = true
		else:
			camera.enabled = true
			drone.camera.enabled = false
			lock_movement = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not lock_movement:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
