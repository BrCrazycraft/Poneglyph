extends Window;

signal fechou(file_name:String, file_type:AbsLang);

@onready var new_name:LineEdit = $style/root/name/new_name;
var exit_name:String = "";
var type:AbsLang = null;


func _on_tipo_item_selected(index:int):
	var options:Array[AbsLang] = [
		TextLang.new(),
		PLang.new(),
		PythonLang.new()
	];
	type = options[index];


func _on_new_name_text_submitted(new_text:String):
	exit_name = new_text;


func _on_criar_pressed():
	if type == null: _on_tipo_item_selected(1);
	if exit_name == "": _on_new_name_text_submitted(new_name.text);
	fechou.emit(exit_name, type);
	queue_free();


func _on_close_requested():
	fechou.emit("", null);
	queue_free()
