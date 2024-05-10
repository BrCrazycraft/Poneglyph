class_name SuperTree extends ScrollContainer

@onready var root:VBoxContainer = $root;

func add(object:Container, path:String = "") -> void:
	root.add_child(object);


func _on_nova_pasta_pressed():
	var wind:Window = load("res://src/workstation/node/suspenso/New_Folder.tscn").instantiate();
	wind.connect("newFolder", new_folder);
	add_child(wind);


func new_folder(folder_name:String) -> void:
	var fold:PanelContainer = load("res://src/workstation/node/fold/Folder.tscn").instantiate();
	root.add_child(fold);
	fold.config(Project.resolve_path(folder_name), folder_name);
	
