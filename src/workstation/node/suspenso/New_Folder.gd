extends Window;

signal newFolder(folder_name:String)

@onready var text_name:LineEdit = $root/text_name;

func _on_close_requested():
	queue_free();


func _on_btn_criar_pressed():
	newFolder.emit(text_name.text);
	queue_free();
