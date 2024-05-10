extends CanvasLayer

@onready var config:PanelContainer = $"configurações";
@onready var root:PanelContainer = $style;
@onready var api:LineEdit = $"configurações/Config/mensagem/API_KEY/entrada";
@onready var folder:LineEdit = $"configurações/Config/mensagem/Project/text_path";

func _on_config_pressed():
	config.show();


func _on_exit_pressed():
	config.hide();


func _on_btn_salvar_pressed():
	Project.path = folder.text.replace("c\\\\:", "c//:").replace("\\", "/")
	Project.API_KEY = api.text;
	config.hide();


func _on_novo_projeto_pressed():
	if Project.API_KEY == "" or Project.path == "":
		add_child(load("res://src/index/node/PopUpErro.tscn").instantiate())
	else:
		get_tree().change_scene_to_packed(load("res://src/workstation/index.tscn"));


func _on_documentação_pressed():
	pass
