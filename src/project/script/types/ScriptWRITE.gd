class_name ScriptWRITE extends ScriptObject;

func _init(new_name:String, pre_code:String = "") -> void:
	type = "WRITE";
	extension = "oni";
	code = pre_code;
	light = load("res://Assets/HighLight/escrita.tres").duplicate();
	name = new_name;


func set_code(new_code:String) -> void:
	code = new_code;

