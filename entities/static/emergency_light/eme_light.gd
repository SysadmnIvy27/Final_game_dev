extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var light = $PointLight2D
@onready var blink_timer = $Blink
var active = true
var blink_delay = 5
var between_blinks = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if active:
		anim.animation = &"active"
	else:
		anim.animation = &"inactive"
		


func _on_blink_timeout() -> void:
	active = not active
	if active:
		var on_tween = create_tween().set_parallel()
		on_tween.tween_property(light,"energy", 1.0, 0.5)
		if on_tween:
			on_tween.kill()
		await on_tween.finished
		blink_timer.start(blink_delay)
		print("Here")
		var off_tween = create_tween().set_parallel()
		off_tween.tween_property(light,"energy", 0, 1.0)
		if off_tween:
			off_tween.kill()
	else: 
		blink_timer.start(between_blinks)
