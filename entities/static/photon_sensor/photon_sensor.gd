extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var light = $PointLight2D
@export var toggleable = true # If true, allowes sensor to turn on and off
var toggled = false
var bound_door
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if active:
		anim.animation = &"active"
		light.color = Color(0.0, 0.706, 0.0, 1.0)
	else:
		anim.animation = &"inactive"
		light.color = Color(0.706, 0.0, 0.0, 1.0)
	
func on_hit():
	if toggleable:
		active = not active
	elif not toggleable and not toggled:
		active = not active
		toggled = true
