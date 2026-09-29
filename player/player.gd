extends CharacterBody2D

@onready var interaction_range = $interaction_range
@onready var camera = $Camera2D
@onready var hud = $CanvasLayer/Hud
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var team = "friendly"
var lock_movement = false
var lock_interaction = false
var lock_drone = false
var drone : Node
var inventory = {}
var slots = 8

func _ready() -> void:
	var level = get_parent()
	print(level.name)
	level.player = self
	# inventory setup
	for slot in slots:
		var slot_id = "slot" + str(slot)
		inventory[slot_id] = {}
		inventory[slot_id]["item"] = ""
		inventory[slot_id]["amount"] = 0
	print(inventory)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and not lock_interaction:
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
	if Input.is_action_just_pressed("swap_drone_action") and drone != null and drone.can_connect and not lock_drone:
		if drone.mode < len(drone.modes):
			drone.mode += 1
		else:
			drone.mode = 1
	if drone != null:
		if drone.mode == 3:
			camera.enabled = false
			drone.camera.enabled = true
			lock_movement = true
			lock_interaction = true
		else:
			camera.enabled = true
			drone.camera.enabled = false
			lock_movement = false
			lock_interaction = false
	
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func add_item(item):
	if item.item_name in Itemdatabase.item_dict: # checks to see if the item exists in the game items dictionary
		var item_added = false # creates a variable to track if the item has been added
		for slot in inventory:
			if not item_added:
				if inventory[slot]["item"] == "" and inventory[slot]["amount"] == 0:
					inventory[slot]["item"] = item.item_name
					inventory[slot]["amount"] = item.amount
					item_added = true
				elif inventory[slot]["item"] == item.item_name:
					inventory[slot]["amount"] += item.amount
					item_added = true
	print(inventory)
