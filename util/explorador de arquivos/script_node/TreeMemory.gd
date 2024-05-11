extends PanelContainer;

@onready var pop_up_mkdir:PopupPanel = $nova_pasta;
@onready var mkdir_name:LineEdit = $nova_pasta/root/nome/new_fold;
@onready var pop_up_rename:PopupPanel = $Renomear;
@onready var rename:LineEdit = $Renomear/style/root/nome/rename;
@onready var pop_up:PopupMenu = $pop_up;
@onready var icon:TextureRect = $root/fold/Icon;
@onready var nome:Label = $root/fold/name;
@onready var grid:GridContainer = $root/style_element/tree;
@export var block:bool = false;
var relative_memory:String = "";
var fold:bool = true;

func config(path:String, is_fold:bool) -> void:
	relative_memory = path;
	fold = is_fold;
	nome.text = path.get_file();
	if is_fold == true:
		icon.texture = load("res://Assets/Imagem/folder.png");
		pop_up.add_item("Novo arquivo", 2);
		pop_up.add_item("Novo Pasta", 3);
	else:
		icon.texture = load("res://Assets/Imagem/file.png");
	update();


func update() -> void:
	for x in grid.get_children(): x.queue_free();
	if fold == true:
		for x in GlobalConfig.project.ls_fold(relative_memory, Memory.LS_ARGS.FILES):
			if not x == "": add_obj(x, false);
		for x in GlobalConfig.project.ls_fold(relative_memory, Memory.LS_ARGS.DIR):
			if not x == "": add_obj(x, true);


func add_obj(e_name:String, is_fold:bool) -> void:
	var obj:PanelContainer = load("res://util/explorador de arquivos/node/TreeMemory.tscn").instantiate();
	grid.add_child(VSeparator.new());
	grid.add_child(obj);
	obj.config(relative_memory + "/" + e_name, is_fold);



func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			if fold == true:
				if grid.visible == true: grid.hide();
				else: grid.show();
			else: GlobalConfig.project.open(relative_memory);
		elif event.button_index == 2:
			menu();


func menu() -> void:
	pop_up.show();
	pop_up.position = get_tree().current_scene.get_window().get_mouse_position();


func _on_pop_up_id_pressed(id):
	if id == 1 and block == false:
		rename.text = relative_memory.get_file();
		pop_up_rename.show();
	elif id == 0 and block == false:
		GlobalConfig.project.remove_fold(relative_memory);
		queue_free();
	elif id == 2:
		var new:Window = load("res://util/explorador de arquivos/node/NewFile.tscn").instantiate();
		new.connect("fechou", new_file);
		add_child(new);
	elif id == 3:
		pop_up_mkdir.show();
		mkdir_name.text = "";
		


func _on_rename_text_changed(new_text): nome.text = new_text;


func _on_rename_text_submitted(new_text):
	if new_text != "" and RegexS.find(new_text, "^[\\w\\s]*$"):
		GlobalConfig.project.rename_fold(relative_memory, new_text);
		if relative_memory.get_extension() == "": relative_memory = relative_memory.substr(0, relative_memory.length()-relative_memory.get_file().length()) + new_text;
		else: relative_memory = relative_memory.substr(0, relative_memory.length()-relative_memory.get_file().length()) + new_text + "." + relative_memory.get_extension();
		nome.text = relative_memory.get_file();
		pop_up_rename.hide();


func new_file(new_name:String, type:AbsLang) -> void:
	if not (new_name == "" or type == null):
		GlobalConfig.project.write_file(relative_memory + "/" + new_name + type.extension, "");
		update();


func _on_new_fold_text_submitted(new_text):
	if new_text != "" and RegexS.find(new_text, "^[\\w\\s]*$"):
		GlobalConfig.project.mkdir(relative_memory, new_text);
		update();
		pop_up_mkdir.hide();
