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
	# movement logic
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damagable"):
		area.on_hit()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("damagable"):
		body.on_hit()
		queue_free()
