@tool class_name TreeScript extends PanelContainer

signal open(object, path)

@onready var btn_name:Button = $root/btn_name
var code:ScriptObject;
var path:String

func config(new_code:ScriptObject, new_path:String ,script_name:String) -> void:
	btn_name.text = script_name + "." + new_code.extension;
	path = new_path;	var parente:Node = find_parent("MAIN")
	code = new_code;
	if ProjectScript.add_script(path, code): queue_free();
	if not parente == null:
		open.connect(parente.open_project);



func _on_btn_name_pressed():
	open.emit(path);


func _on_btn_delete_pressed():
	Project.delete(path);
	queue_free();
