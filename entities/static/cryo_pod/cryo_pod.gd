extends Area2D

@export var spawned_entity : PackedScene
var contained_entity : Node
@onready var door_anim = $"Door"
@onready var camera = $Camera2D
@onready var Start = $"../Start"
@onready var End = $"../End"
var occupied = true
var player_initial_spawn = false
var deployed = false
var deploying = false
var stowing = false
var deploy_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Start.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if deploying:
		deploy(delta)
	if stowing:
		stow(delta)
	
	if Input.is_action_just_pressed("enter_cryo") and not player_initial_spawn and deployed == true and occupied:
		var entity = spawned_entity.instantiate()
		get_tree().current_scene.add_child(entity)
		entity.camera.enabled = true
		player_initial_spawn = true
		camera.enabled = false
		occupied = false
	elif Input.is_action_just_pressed("enter_cryo") and not player_initial_spawn and deployed == false and occupied:
		deploying = true
	elif Input.is_action_just_pressed("enter_cryo") and player_initial_spawn and deployed == false and occupied:
		deploying = true
	elif Input.is_action_just_pressed("enter_cryo") and player_initial_spawn and deployed == true and occupied and not stowing:
		contained_entity.visible = true
		contained_entity.camera.enabled = true
		contained_entity.lock_movement = false
		contained_entity.lock_interaction = false
		camera.enabled = false
		occupied = false

func deploy(delta):
	if not deployed:
		var direction = (End.global_position - global_position).normalized()
		global_position += direction * deploy_speed * delta
		if ((global_position.y + 1) > End.global_position.y and (global_position.y - 1) < End.global_position.y):
			global_position = End.global_position
			deployed = true
			deploying = false
			door_anim.play("default")
				
func stow(delta):
	if deployed:
		var direction = (Start.global_position - global_position).normalized()
		global_position += direction * deploy_speed * delta
		if ((global_position.y + 1) > Start.global_position.y and (global_position.y - 1) < Start.global_position.y):
			global_position = Start.global_position
			stowing = false
			deployed = false

func interact(entity):
	if entity.is_in_group("player"):
		contained_entity = entity
		entity.visible = false
		entity.camera.enabled = false
		camera.enabled = true
		stowing = true
		occupied = true
		door_anim.play_backwards("default")
		entity.lock_movement = true
		entity.lock_interaction = true
