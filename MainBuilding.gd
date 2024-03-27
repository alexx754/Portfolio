extends Building

class_name MainBuilding

func _ready():
	super._ready()
	building_type = building_types.MAIN_BUILDING
	cost = 500
	spawning_unit = WORKER_UNIT
	spawning_img = WORKER_UNIT_IMG
	unit_img = preload("res://Images/Rathaus.jpg")
	rts_controller.main_buildings.append(self)
	
func lower_health(damage_inflected):
	health -= damage_inflected
	unit_health_bar.value = health
	if health <= 0:
		queue_free()



func _on_tree_exiting():
	rts_controller.main_buildings.erase(self)
