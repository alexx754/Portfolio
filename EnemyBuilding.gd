extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	building_type = building_types.ENEMY_BUILDING
	

func lower_health(damage_inflected):
	health -= damage_inflected
	unit_health_bar.value = health
	if health <= 0:
		queue_free()
