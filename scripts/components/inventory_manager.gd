extends Node

@export var owner_entity = get_parent()
var slots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots = owner_entity.slots
	# inventory setup
	for slot in slots:
		var slot_id = "slot" + str(slot)
		owner_entity.inventory[slot_id] = {}
		owner_entity.inventory[slot_id]["item"] = ""
		owner_entity.inventory[slot_id]["amount"] = 0
	print(owner_entity.inventory)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item):
	if item.item_name in Itemdatabase.item_dict: # checks to see if the item exists in the game items dictionary
		var item_added = false # creates a variable to track if the item has been added
		for slot in owner_entity.inventory:
			if not item_added:
				if owner_entity.inventory[slot]["item"] == "" and owner_entity.inventory[slot]["amount"] == 0:
					owner_entity.inventory[slot]["item"] = item.item_name
					owner_entity.inventory[slot]["amount"] = item.amount
					item_added = true
				elif owner_entity.inventory[slot]["item"] == item.item_name:
					owner_entity.inventory[slot]["amount"] += item.amount
					item_added = true
	print(owner_entity.inventory)
