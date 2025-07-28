extends Node

var last_tile_index: int = 0
var firebase_uid: String = ""
var firebase_id_token: String = ""
var points: int = 0
var tBucks: int = 0
var username: String = ""
var quiver_request: HTTPRequest = null  # to be assigned from the scene


func add_points(value: int) -> void:
	points += value
	if points < 0:
		points = 0

func add_tBuck(value: int) -> void:
	tBucks += value
	if tBucks < 0:
		tBucks = 0
		

# Fixed function name (removed asterisks)
func _on_quiver_response(_result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	if code == 200:
		print("✅ Quiver submission success:", response)
	else:
		print("❌ Quiver submission failed:", response)

func send_to_quiver(name: String, score: int, truthBucks: int):
	if not quiver_request:
		print("❌ Quiver HTTPRequest not assigned.")
		return
	
	# Connect the signal if not already connected
	if not quiver_request.request_completed.is_connected(_on_quiver_response):
		quiver_request.request_completed.connect(_on_quiver_response)
	
	var url = "https://api.quiver.dev/v1/leaderboards/truthiego-truthiego-0rxo/scores"
	var headers = [
		"Content-Type: application/json",
		"Authorization: MASKED"
	]
	var body = {
		"score": score,
		"player": {
			"name": name,
			"truthBucks": truthBucks
		}
	}
	var json = JSON.stringify(body)
	var err = quiver_request.request(url, headers, HTTPClient.METHOD_POST, json)
	if err != OK:
		print("❌ Quiver submission error:", err)
	else:
		print("✅ Submitted to Quiver:", json)

# Helper function to initialize the HTTPRequest from a scene
func setup_quiver_request(http_request: HTTPRequest):
	quiver_request = http_request
	if not quiver_request.request_completed.is_connected(_on_quiver_response):
		quiver_request.request_completed.connect(_on_quiver_response)
