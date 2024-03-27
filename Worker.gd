extends Unit

class_name Worker

@onready var build_timer = $WorkTimer
@onready var mine_timer = $MineTimer

var minerals : int = 0
var stracture_to_build
var mineral_field_to_mine
var rock_mine = false
var mine_point : Vector3


func _ready():
	super._ready()
	unit_type = unit_types.WORKER
	cost = 35
	damage = 5
	unit_img = preload("res://Images/Arbeiter.jpg")


func create_stracture(stracture):
	stracture.position = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), rts_controller.raycast_from_mouse(1).position)
	stracture.create_stracture(self)
	nav_region.add_child(stracture)
	
func build_stracture(stracture):
	stracture_to_build = stracture
	move_to(lerp_from_self(stracture_to_build.get_global_transform().origin))
	change_state("building")

func work():
	speed = 0.000001
	state_machine.travel("Build")
	build_timer.start()

func move_to(target_pos):
	super.move_to(target_pos)
	build_timer.stop()

func _on_navigation_agent_3d_target_reached():
	if current_state == states.BUILDING:
		work()
	elif current_state == states.MINING and !rock_mine:
		mine()
	elif current_state == states.MINING and rock_mine:
		await get_tree().create_timer(0.05).timeout
		minerals -=5
		gui_controller.add_minerals(5)
		rock_mine = false
		mining_reapeat()
	elif current_state == states.ATTACKING:
		attack()
	else:
		build_timer.stop()
		change_state("idle")

func lerp_from_self(position):
	var change_point_by = 0
	var point = position.lerp(get_global_transform().origin,change_point_by)
	var desired_distance = 2.5 # IMPORTANT CODE LINE different building have different desired values
	
	while point.distance_to(position) < desired_distance:
		change_point_by += 0.01
		point = position.lerp(get_global_transform().origin,change_point_by)
		if point.distance_to(position) >= desired_distance:
			break
		return point


func mine():
	speed = 0.000001
	state_machine.travel("Build")
	mine_timer.start()

func mining_reapeat():
	move_to(mine_point)
	change_state("mining")
	
func return_to_base():
	var lowest_distance = 0
	var closest_building = null
	for main_building in rts_controller.main_buildings:
		var distance_between = global_transform.origin.distance_to(main_building.global_transform.origin)
		if lowest_distance == 0 or distance_between < lowest_distance:
			if main_building.active:
				closest_building = main_building
				lowest_distance = distance_between
	if closest_building != null:
		move_to(lerp_from_self(closest_building.get_global_transform().origin))
		change_state("mining")

func add_minerals():
	if minerals != 5:
		minerals += 5
	return_to_base()
	rock_mine = true
	mine_timer.stop()
	
func mine_mineral_field(mineral_field):
	if minerals == 5:
		return_to_base()
	else:
		mineral_field_to_mine = mineral_field
		var pos_in_field = mineral_field_to_mine.get_field_pos()
		mine_point = lerp_from_self(pos_in_field)
		move_to(mine_point)
		change_state("mining")


func _on_work_timer_timeout():
	stracture_to_build.add_health(self)
	
	
func _on_mine_timer_timeout():
	mineral_field_to_mine.mine_field(self)




func _on_attack_timer_timeout():
	search_for_enemies("enemy")
	search_for_enemies("enemy_building")
