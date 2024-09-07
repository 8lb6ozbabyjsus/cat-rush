extends Node


# Replace with your OpenAI API key
@export var api_key: String = "YOUR_OPENAI_API_KEY"
var api_url: String = "https://api.openai.com/v1/chat/completions"

@export var default_prompt: String = "Hello, how can I help you today?"  # Exported for easy editing

@onready var http_request: HTTPRequest = HTTPRequest.new()

func _ready() -> void:
	# Initialize HTTPRequest node
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)  # Updated signal connection

	# Example of making an API call
	send_request(default_prompt)

func send_request(prompt: String) -> void:
	var headers: Array[String] = ["Authorization: Bearer " + api_key, "Content-Type: application/json"]
	var body: Dictionary = {
		"model": "gpt-3.5-turbo",
		"messages": [{"role": "user", "content": prompt}],
		"max_tokens": 100
	}
	var body_json: String = JSON.stringify(body)  # Corrected JSON.stringify for GDScript 2.0
	http_request.request(api_url, headers, HTTPClient.METHOD_POST, body_json)  # Use HTTPClient.METHOD_POST

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		var response: Dictionary = JSON.parse_string(body.get_string_from_utf8())  # Updated JSON parsing
		if response.has("choices") and response["choices"].size() > 0:
			var reply: String = response["choices"][0]["message"]["content"]
			print("OpenAI Response: ", reply)
		else:
			print("Error: Unexpected response format")
	else:
		print("HTTP Request failed with response code: ", response_code)
