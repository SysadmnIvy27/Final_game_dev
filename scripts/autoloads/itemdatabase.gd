extends Node

var item_dict = {}
var default_path = "res://entities/items/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for dir in DirAccess.get_directories_at(default_path):
		var files_path = default_path + dir
		for file in DirAccess.get_files_at(files_path):
			if file.ends_with(".tscn"):
				var pack_scene = load(default_path + dir + "/" + file)
				var scene = pack_scene.instantiate()
				item_dict[scene.item_name] = {}
				item_dict[scene.item_name]["texture"] = scene.texture
				item_dict[scene.item_name]["packed_scene"] = pack_scene
				scene.queue_free()
	print(item_dict)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
