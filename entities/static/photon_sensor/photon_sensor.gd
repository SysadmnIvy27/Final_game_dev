extends Area2D

@onready var anim = $AnimatedSprite2D
var bound_door
var active = false
var door
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if active:
		anim.animation = &"active"
		bound_door.open = true
	else:
		anim.animation = &"inactive"
		bound_door.open = false
	
func on_hit():
	active = not active
		
