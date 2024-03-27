extends SubViewportContainer

@onready var map_camera : Camera3D = $SubViewport/Camera3D
@onready var rts_controller = get_tree().get_root().get_node("World/RTSController")

var start_pos = Vector2()
var end_pos = Vector2()
var raycasts : Array[Vector2]
var add_to_size = 10
var world_extents : Rect2 = Rect2(0,0,200,200)

func move_to(unit_pos):
	var half_world_extents = world_extents.size * 0.5
	unit_pos += half_world_extents
	var paintbrush_position = unit_pos / world_extents.size
	var camera_position = paintbrush_position * size
	return camera_position

func _draw():
	raycasts = rts_controller.get_camera_raycasts()
	draw_line(move_to(Vector2(raycasts[0].x - add_to_size ,raycasts[0].y)),
	move_to(Vector2(raycasts[1].x - add_to_size ,raycasts[1].y)),Color.CORNFLOWER_BLUE)
	draw_line(move_to(Vector2(raycasts[1].x - add_to_size ,raycasts[1].y)),
	move_to(Vector2(raycasts[2].x + add_to_size ,raycasts[2].y)),Color.CORNFLOWER_BLUE)
	draw_line(move_to(Vector2(raycasts[2].x + add_to_size ,raycasts[2].y)),
	move_to(Vector2(raycasts[3].x + add_to_size ,raycasts[3].y)),Color.CORNFLOWER_BLUE)
	draw_line(move_to(Vector2(raycasts[3].x + add_to_size ,raycasts[3].y)),
	move_to(Vector2(raycasts[0].x - add_to_size ,raycasts[0].y)),Color.CORNFLOWER_BLUE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()




func _on_mini_map_gui_input(event):
	if Input.is_action_pressed("select"):
		var mouse_pos = $SubViewport.get_mouse_position()
		var camera_pos : Vector3 = rts_controller.global_transform.origin
		
		camera_pos = Vector3(mouse_pos.x/((size.x/2)/(world_extents.size.x * 0.5)) - 100,
		camera_pos.y,
		mouse_pos.y/((size.x/2)/(world_extents.size.x * 0.5)) - 100)
		
		if camera_pos.x < -62:
			camera_pos.x = -61
		if camera_pos.z < -65:
			camera_pos.z = -64
		if camera_pos.x > 62:
			camera_pos.x = 61
		if camera_pos.z > 90:
			camera_pos.z = 89
		rts_controller.global_transform.origin = camera_pos

