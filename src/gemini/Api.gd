@tool class_name GeminiAPI extends HTTPRequest

signal response(text:String)
signal erro(text)

@export var Request:String = ""
@export var API_KEY:String = ""
var link:String = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="

func _ready() -> void:
	request_completed.connect(_response)


func make_request() -> void:
	var json:Dictionary = {
		"contents": {
			"parts": [
				{ "text": Request }
			]
		}
	}
	request(link + API_KEY, ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(json));



func _response(result:int, response_code:int, headers, body:PackedByteArray) -> void:
	var response_json:Dictionary = JSON.parse_string(body.get_string_from_utf8());
	
	if response_code == HTTPClient.RESPONSE_OK:
		response.emit(response_json["candidates"][0]["content"]["parts"][0]["text"]);
	else:
		printerr("Resultado: {} [{}]".format([result, response_code]))
