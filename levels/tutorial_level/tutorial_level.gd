extends Node2D

var msg_on_entered = "Cryo bay: Sector 3"
#@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#player.hud.push_message(msg_on_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
