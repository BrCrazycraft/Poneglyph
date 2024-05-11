class_name FileExplore extends Node;

signal target(path:String);

@onready var target_item:LineEdit = $Index/style/root/syle_menu/menu/item_name;
@onready var fold_name:LineEdit = $nova_pasta/style/root/nome/rename;
@onready var mkdir:PopupPanel = $nova_pasta;
@onready var diretorio:LineEdit = $Index/style/root/style_nav/navigation/diretorio;
@onready var grid_content = $Index/style/root/style_area/grid;
var memory:Memory = Memory.new();


func _ready() -> void:
	memory.dir_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);
	update();

func update() -> void:
	diretorio.text = memory.dir_path;
	for x in grid_content.get_children(): x.queue_free();
	for x in memory.ls(memory.LS_ARGS.DIR):
		if not x.is_empty():
			add(x, true)
	for x in memory.ls(memory.LS_ARGS.FILES):
		if not x.is_empty():
			add(x, false)


func add(item:String, folder:bool) -> void:
	var fold:PanelContainer = load("res://util/explorador de arquivos/node/ViewMemory.tscn").instantiate();
	grid_content.add_child(fold);
	fold.connect("abriu", abriu)
	fold.connect("delete", delete)
	fold.connect("rename", rename)
	fold.connect("selecionou", selecionou);
	fold.config(item, folder);

func abriu(file_name:String, is_file:bool) -> void:
	if is_file == false and memory.cd(file_name):
		update();


func selecionou(file_name:String, is_file:bool) -> void:
	if is_file == false:
		target_item.text = file_name;
		


func rename(file_name:String, old_name:String, is_file:bool) -> void:
	memory.rename(file_name, old_name);
	update();


func delete(file_name:String, is_file:bool) -> void:
	memory.remove(file_name);
	update();


func _on_diretorio_text_submitted(new_text:String):
	new_text = new_text.replace("\\", "/");
	if new_text != "" and memory.to_absolute(new_text):
		update();
	else:
		diretorio.text = memory.dir_path;


func _on_voltar_pressed():
	if memory.cd("../"): update();


func _on_nova_pasta_pressed():
	mkdir.show();
	fold_name.text = "";


func _on_nova_pasta_popup_hide():
	var mk_name:String = fold_name.text;
	if mk_name != "" and RegexS.find(mk_name, "^[\\w\\s]*$"):
		memory.mkdir(mk_name);
		update();



func _on_rename_text_submitted(new_text):
	var mk_name:String = fold_name.text;
	mkdir.hide();
	if mk_name != "" and RegexS.find(mk_name, "^[\\w\\s]*$"):
		memory.mkdir(mk_name);
		update();


func _on_index_close_requested():
	target.emit("");
	queue_free();


func _on_confirmar_pressed():
	if memory.cd(target_item.text):
		target.emit(memory.dir_path);
		queue_free();


func _on_pasta_atual_pressed():
	target.emit(memory.dir_path);
	queue_free();
