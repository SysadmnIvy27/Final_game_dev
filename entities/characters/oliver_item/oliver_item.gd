extends CharacterBody2D

var owner_entity : Node
var movement_marker : Node
var move_target : Node
@onready var attack_range = $attack_area
@onready var attack_collision = $attack_area/CollisionShape2D
@onready var interact_range = $interact_area
@onready var detection_range = $detection_range
@onready var timer = $Cooldown
@onready var tooltip = $tooltip
@onready var camera = $Camera2D
@onready var thrust_pivot = $thruster_pivot
@onready var turret_pivot = $turret_pivot
@onready var projectile_spawn = $turret_pivot/projectile_spawn
@onready var shoot_ray = $turret_pivot/RayCast2D
# lights
@onready var body_light = $PointLight2D
@onready var turret_light = $turret_pivot/PointLight2D
@onready var thruster_light = $thruster_pivot/PointLight2D
# exported vars
@export var projectile_scene : PackedScene
# standard vars
var has_owner = false
var can_connect = true
var debug = false
var SPEED = 100.0
var sprint_speed = 200.0
var default_speed = 100.0
var team
var cooldown = 0.1
var follow_dist = 30
var signal_range = 500
var modes = ["Sentry","AI","Player Control"]
var mode = 1
var turret_speed = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turret_radius = attack_collision.get_shape().get_radius() 
	shoot_ray.target_position = shoot_ray.target_position.normalized()
	shoot_ray.target_position = (shoot_ray.target_position) * turret_radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if has_owner:
		if modes[mode - 1] == "Sentry":
			Sentry_mode()
		elif modes[mode - 1] == "AI":
			AI_mode(delta)
		elif modes[mode - 1] == "Player Control":
			Player_Ctrl(delta)
			
		if global_position.distance_to(owner_entity.global_position) > signal_range and mode == 3:
			mode = 1
			can_connect = false
			owner_entity.hud.push_message("Drone connection offline.")
		else:
			can_connect = true
			owner_entity.hud.push_message("Drone connection online.")
		
func Sentry_mode():
	velocity = Vector2.ZERO
	attack()
	animate()
	

func AI_mode(delta):
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
	target_dist = INF
	for target in targets:
		if target.is_in_group("interactable"):
			if global_position.distance_to(target.global_position) < target_dist:
				closest_target = target
				target_dist = global_position.distance_to(target.global_position)
	move_target = closest_target
	if closest_target != null and debug:
		print("The closest target is: " + closest_target.name + " " + str(target_dist))
	
	if debug:
		print("List Start:")
		for target in targets:
			print(target.name + " distance: " + str(global_position.distance_to(target.global_position)))
	
	if move_target == null:
		move_target = movement_marker
	
	var movement_direction = (move_target.global_position - global_position).normalized()
	
	var dist = global_position.distance_to(move_target.global_position)
	
	if dist > follow_dist and move_target == movement_marker: # follow logic
		velocity = movement_direction * SPEED
	elif move_target != movement_marker:
		velocity = movement_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		if debug:
			print(str(velocity))
			
	animate()
	move_and_slide()
	
	attack()
	interaction()
	
func Player_Ctrl(delta):
	var direction : Vector2
	var mouse = get_global_mouse_position()
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	if Input.is_action_pressed("sprint"):
		SPEED = sprint_speed
	else:
		SPEED = default_speed
	
	if direction:
		velocity = (direction * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		
	if Input.is_action_pressed("rotate_left") and rotation_degrees >= -20:
		rotation -= deg_to_rad(1.0)
	if Input.is_action_pressed("rotate_right") and rotation_degrees <= 20:
		rotation += deg_to_rad(1.0)
	
	var aim = (mouse - turret_pivot.global_position).normalized()
	var angle_diff = rad_to_deg(turret_pivot.transform.x.angle_to(aim))
	if (turret_pivot.rotation_degrees + angle_diff) > -6 + rotation_degrees and (turret_pivot.rotation_degrees + angle_diff) < 166 + rotation_degrees:
		turret_pivot.look_at(mouse)
		if Input.is_action_pressed("fire1") and timer.is_stopped():
			timer.start(cooldown)
			shoot(mouse)
	if debug:
		print("Angle Difference: " + str(angle_diff))
		print("Current Angle: " + str(turret_pivot.rotation_degrees))
	
	animate()
	move_and_slide()
	interaction()
	
func attack():
	# attack logic
	if timer.is_stopped() and has_owner:
		for area in attack_range.get_overlapping_areas():
			if area.is_in_group("targetable") and (area.team != "neutral" and area.team != team):
				var aim = (area.global_position - turret_pivot.global_position).normalized()
				var angle_diff = rad_to_deg(turret_pivot.transform.x.angle_to(aim))
				if (turret_pivot.rotation_degrees + angle_diff) > -6 + rotation_degrees and (turret_pivot.rotation_degrees + angle_diff) < 166 + rotation_degrees:
					turret_pivot.look_at(area.global_position)
					shoot_ray.force_raycast_update()
					if debug:
						print("Colliding with:" + str(shoot_ray.get_collider()))
					if shoot_ray.get_collider() == area:
						shoot(area.global_position)
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
	turret_pivot.look_at(entity)
	var projectile = projectile_scene.instantiate() #instance projectile
	var direction = (entity - projectile_spawn.global_position).normalized()
	projectile.direction = direction
	projectile.team = team
	projectile.global_position = projectile_spawn.global_position
	projectile.owner_entity = self
	projectile.rotation = direction.angle()
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
		body_light.visible = true
		turret_light.visible = true
		thruster_light.visible = true
		
func animate():
	if velocity.x > 0:
		thrust_pivot.rotation_degrees = 60 - rotation_degrees
	elif velocity.x < 0:
		thrust_pivot.rotation_degrees = -40 - rotation_degrees
	elif velocity.x == 0:
		thrust_pivot.rotation_degrees = 0 - rotation_degrees
