extends Control

@onready var owmer_entity = get_parent()
@onready var message_label = $Notification_msg
@onready var area_notifer =  $Room_notification
@onready var area_timer = $Room_Timer
@onready var connection_icon = $TextureRect
var connection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if area_timer.is_stopped():
		area_notifer.visible = false
		
	if connection == true:
		connection_icon.texture.region = Rect2(0,0,32,32)
	else:
		connection_icon.texture.region = Rect2(0,32,32,32)

func push_message(message):
	message_label.text = message
	
func area_entered(message):
	area_timer.start(3.0)
	area_notifer.visible = true
	area_notifer.text = message
