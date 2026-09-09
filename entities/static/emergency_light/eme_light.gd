extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var light = $PointLight2D
@onready var blink_timer = $Blink
var active = true
var blink_delay = 5
var between_blinks = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if active:
		anim.animation = &"active"
		light.visible = true
	else:
		anim.animation = &"inactive"
		light.visible = false


func _on_blink_timeout() -> void:
	active = not active
	if active:
		blink_timer.start(blink_delay)
	else: 
		blink_timer.start(between_blinks)
