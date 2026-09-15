extends Node2D

var msg_on_entered = "Cryo bay: Sector 3"
var player : Node
var msg_sent = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	player = get_parent().player
	if player and not msg_sent:
		player.hud.area_entered(msg_on_entered)
		msg_sent = true
