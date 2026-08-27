extends Area2D

# nodes
@onready var projectile_collision = $CollisionShape2D
@onready var timer = $Timer
# vars
const speed = 300
var lifetime = 2.0
var direction = Vector2.ZERO
var team

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(lifetime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	if timer.is_stopped():
		queue_free()
