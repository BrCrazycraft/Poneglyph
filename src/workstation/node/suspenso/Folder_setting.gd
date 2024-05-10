extends Window

signal delete();
signal novo(script:ScriptObject);

@onready var text_name:LineEdit = $root/style/element/script/script_name;
var idx:int = 0;

func _on_btn_deletar_pressed():
	delete.emit();
	queue_free();


func _on_create_pressed():
	novo.emit(ProjectScript.create_index(idx, "", text_name.text));
	queue_free();

func _on_close_requested():
	queue_free();
