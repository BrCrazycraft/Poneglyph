extends PanelContainer

#===============================================================================
#		Sinais
#===============================================================================
signal abriu(file_name:String, file_type:bool);
signal selecionou(file_name:String, old_name:String, file_type:bool);
signal rename(file_name:String, file_type:bool);
signal delete(file_name:String, file_tpye:bool);

#===============================================================================
#		Variaveis
#===============================================================================
#===> Referencias <====#
@onready var color:ColorRect = $color;
@onready var view_name:Label = $item/name;
@onready var view_icon:TextureRect = $item/Icon;
@onready var config_menu:PopupMenu = $pop_up;
@onready var folder_name:PopupPanel = $rename;
@onready var folder_name_line:LineEdit = $rename/style/root/nome/rename;
#===> Nome das variaveis <===#
var file_name:String = "<nome>";
var file:bool = true;

#===============================================================================
#		Funções
#===============================================================================
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.double_click == true:
			abriu.emit(file_name, file);
		elif event.button_index == 1:
			color.color = Color.LIGHT_STEEL_BLUE;
			selecionou.emit(file_name, file);
		elif event.button_index == 2:
			menu();


func config(new_name:String, fold:bool) -> void:
	file_name = new_name;
	view_name.text = file_name;
	file = not fold;
	if file == true: view_icon.texture = load("res://Assets/Imagem/file.png");
	else: view_icon.texture = load("res://Assets/Imagem/folder.png");



func menu() -> void:
	config_menu.show();
	config_menu.position = get_tree().current_scene.get_window().get_mouse_position();



func _on_pop_up_id_pressed(id:int):
	if id == 1: 
		folder_name_line.text = file_name;
		folder_name.show();
	elif id == 0: delete.emit(file_name, file);


func _on_rename_popup_hide():
	if view_name.text != "" and RegexS.find(view_name.text, "^[\\w\\s]*$"):
		var old:String = file_name;
		file_name = view_name.text;
		rename.emit(file_name, old, file);
	else:
		view_name.text = file_name;

func _on_rename_text_changed(new_text:String) -> void: view_name.text = new_text;


func _on_mouse_exited(): color.color = Color.TRANSPARENT;
