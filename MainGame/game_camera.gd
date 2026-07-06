extends Camera2D

@onready var player = $"../Player"

var following_player: bool = true
#var last_cam_pos = Vector2()
var cam_pos_tween: Tween # for smooth animation

func _ready() -> void:
	zoom.x = 4
	zoom.y = 4
	position = player.position

func _input(event: InputEvent) -> void:
	
	# Don't do anything on key up
	if event.is_released():
		return
	
	if event.is_action_pressed("zoom_in"):
		zoom.x += 0.5
		zoom.y += 0.5
		
	if event.is_action_pressed("zoom_out"):
		zoom.x -= 0.5
		zoom.y -= 0.5
	 
	if event.is_action_pressed("camera_follow"):
		if following_player:
			following_player = false
			print("Camera unfollowing player")
		elif not following_player:
			following_player = true
			_on_player_movement_action() # move cam to player
			print("Camera following player")

# hold mouse buttons to drag camera
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE or event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative / zoom

# follow player
func _on_player_movement_action() -> void:
	if following_player:
		if cam_pos_tween:
			cam_pos_tween.kill()
		cam_pos_tween = create_tween()
		cam_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		cam_pos_tween.tween_property(self,"position",player.position, 0.185).set_trans(Tween.TRANS_SINE)

func display_player_arrow() -> void:
	pass # display arrow of player location if out of camera view
