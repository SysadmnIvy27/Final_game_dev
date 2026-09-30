extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var light = $PointLight2D
@onready var blink_timer = $Blink
var active = true
var blink_delay = 3
var between_blinks = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_blink_timeout() -> void:
	active = not active
	if active:
		light.visible = true
		blink_timer.start(blink_delay)
		await blink_timer.timeout
		var off_tween = get_tree().create_tween()
		off_tween.tween_property(light,"energy", 0, 2.0)
		await off_tween.finished
		anim.animation = &"active"
		light.visible = false
		light.energy = 1.0
	else: 
		anim.animation = &"inactive"
		blink_timer.start(between_blinks)
