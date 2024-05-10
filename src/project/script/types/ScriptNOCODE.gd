class_name ScriptNoCode extends ScriptObject;

func _init(new_name:String, pre_code:String = "") -> void:
	type = "NOCODE";
	extension = "wano";
	code = pre_code;
	light = load("res://Assets/HighLight/logica.tres").duplicate();
	name = new_name;
	prompt = "Haja como um compilador e me transforme esse pesudo codigo em esse pseudo codigo em codigo Python, me retorne somente o codigo em python: "


func set_code(new_code:String) -> void:
	code = new_code;
