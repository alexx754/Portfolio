extends PathFollow3D


func _physics_process(delta: float) -> void:
	const move_speed:= 2.0
	progress += move_speed * delta
