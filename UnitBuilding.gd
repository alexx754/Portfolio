extends Building

class_name UnitBuilding

func _ready():
	super._ready()
	building_type = building_types.UNIT_BUILDING
	cost = 300
	spawning_unit = WARRIOR_UNIT
	spawning_img = WARRIOR_UNIT_IMG
	unit_img = preload("res://Images/Kaserne.jpg")
	
func lower_health(damage_inflected):
	health -= damage_inflected
	unit_health_bar.value = health
	if health <= 0:
		queue_free()
