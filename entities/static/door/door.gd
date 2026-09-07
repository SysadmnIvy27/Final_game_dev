extends StaticBody2D

@onready var door_collision = $CollisionShape2D
@export var open = false
@export var open_con = "All" # current open condition
var open_cons = ["All", "Avg", "None"] # Tells the door under what conditions it should open
var error_on_nill_crtl = true
var switches : Array
var ID = name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child.is_in_group("Door"):
			switches.append(child)
			child.bound_door = self
	
	if len(switches) == 0 and error_on_nill_crtl:
		set_process(false)
		assert(false,"Error, door has no avaliable switches and will not work! Please add switches or link it to an override.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# open / close logic
	if open == true:
		door_collision.disabled = true
	else:
		door_collision.disabled = false
	
	# gathering data
	var num_sensors = len(switches)
	var active_sensors = 0
	for switch in switches:
		if switch.active:
			active_sensors += 1
	
	# condition logic
	if open_con == "All": # checks if all sensors / switches are active
		if active_sensors == num_sensors:
			open = true
		else:
			open = false
	elif open_con == "Avg": # checks if half or more sensors are active
		if (float(active_sensors) / float(num_sensors)) >= 0.5:
			open = true
		else:
			open = false 
	elif open_con == "None": # checks if no sensors are active
		if active_sensors == 0:
			open = true
		else:
			open = false
