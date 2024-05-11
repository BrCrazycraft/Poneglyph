class_name PLang extends AbsLang;

func _init() -> void:
	prompt = "Haja como um compilador e me transforme esse pesudo codigo em esse pseudo codigo em codigo Python, me retorne somente o codigo em python: ";
	extension = ".wano";
	light = load("res://util/gemini/Linguagens/PLang.tres");
