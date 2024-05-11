class_name TextLang extends AbsLang;


func _init() -> void:
	prompt = "<null>"
	light = load("res://util/gemini/Linguagens/TextLang.tres")
	extension = ".txt";


func get_prompt(code:String) -> String:
	return "<null>";
