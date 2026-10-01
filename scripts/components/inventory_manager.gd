extends Node

@onready var owner_entity = get_parent()
@export var slots = 8
@export var debug = false
var inventory = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# inventory setup
	for slot in slots:
		var slot_id = "slot" + str(slot)
		inventory[slot_id] = {}
		inventory[slot_id]["item"] = ""
		inventory[slot_id]["amount"] = 0
	if debug:
		print(owner_entity.name)
		print(inventory)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item):
	if item.item_name in Itemdatabase.item_dict: # checks to see if the item exists in the game items dictionary
		var item_added = false # creates a variable to track if the item has been added
		for slot in inventory:
			if not item_added:
				if inventory[slot]["item"] == "" and inventory[slot]["amount"] == 0:
					inventory[slot]["item"] = item.item_name
					inventory[slot]["amount"] = item.amount
					item.queue_free()
					item_added = true
				elif inventory[slot]["item"] == item.item_name:
					inventory[slot]["amount"] += item.amount
					item.queue_free()
					item_added = true
	if debug:
		print(inventory)
