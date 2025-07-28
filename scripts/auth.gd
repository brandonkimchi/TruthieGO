extends Control

var webApiKey = "MASKED"
var signupUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="
var loginUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="

func _loginSignup(url: String, email: String, password: String):
	var http = $HTTPRequest
	var body = JSON.stringify({
	"email": email,
	"password": password,
	"returnSecureToken": true
})

	var headers = ['Content-Type: application/json'] 
	var error = await http.request(url, headers, HTTPClient.METHOD_POST, body) 
	 
func _on_http_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200:
		Globals.firebase_uid = response["localId"]
		Globals.firebase_id_token = response["idToken"]
		print("✅ Login success! UID:", Globals.firebase_uid)
		get_tree().change_scene_to_file("res://scenes/login_name.tscn")  # Go to next screen
	else:
		print("❌ Login failed:", response)


func _on_login_button_pressed() -> void:
	var url = loginUrl + webApiKey
	var email = $email.text
	var password = $password.text
	
	_loginSignup(url, email, password)


func _on_register_button_pressed() -> void:
	var url = signupUrl + webApiKey
	var email = $email.text 
	var password = $password.text 
	
	_loginSignup(url, email, password)
	
