class_name TreeFlod extends PanelContainer

@onready var btn_name:Button = $root/menu/btn_name
@onready var treeContanier:GridContainer = $root/childs
var path:String;

func config(new_path:String, fold_name:String) -> void:
	path = new_path;
	btn_name.text = fold_name;


func add(object:Container) -> void:
	treeContanier.add_child(VSeparator.new());
	treeContanier.add_child(object);


func _on_btn_name_pressed():
	var on:bool = treeContanier.visible;
	
	if on == true:
		treeContanier.hide();
	else:
		treeContanier.show();


func _on_btn_config_pressed():
	var insta:Window = load("res://src/workstation/node/suspenso/Folder_setting.tscn").instantiate();
	insta.connect("delete", config_delete)
	insta.connect("novo", config_new_script)
	add_child(insta);


func config_delete() -> void:
	print(path)
	Project.delete(path);
	queue_free();


func config_new_script(new_script:ScriptObject) -> void:
	var object:PanelContainer = load("res://src/workstation/node/script/ScriptFile.tscn").instantiate();
	add(object);
	object.config(new_script, path + "/" + new_script.name + "." + new_script.extension, new_script.name);
	print(path)
