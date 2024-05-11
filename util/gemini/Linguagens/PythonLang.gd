class_name PythonLang extends AbsLang;

func _init() -> void:
	prompt = "<null>";
	light = load("res://util/gemini/Linguagens/PythonLang.tres");
	extension = ".py";


func get_prompt(code:String) -> String: return "<null>";
