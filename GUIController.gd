extends Control

#Units and building scenes
const MAIN_BUILDING: PackedScene = preload("res://Scenes/MainBuilding.tscn")
const UNIT_BUILDNG: PackedScene = preload("res://Scenes/UnitBuilding.tscn")
const WORKER_UNIT: PackedScene = preload("res://Scenes/Worker.tscn")
const WARRIOR_UNIT: PackedScene = preload("res://Scenes/Warrior.tscn")

#Units and building images
const MAIN_BUILDING_IMG: CompressedTexture2D = preload("res://Images/Rathaus.jpg") 
const UNIT_BUILDING_IMG: CompressedTexture2D = preload("res://Images/Kaserne.jpg") 
const UNIT_WORKER_IMG: CompressedTexture2D = preload("res://Images/Arbeiter.jpg") 
const UNIT_WARRIOR_IMG: CompressedTexture2D = preload("res://Images/Infanterie.jpg") 

@onready var main_unit_img = $MainUnitImageContainer/MainUnitImage
@onready var button_one_img = $SelectionBar/BuildingsGrid/OptionButtonOne
@onready var button_two_img = $SelectionBar/BuildingsGrid/OptionButtonTwo
@onready var minerals_label = $Minerals/Label

var unit_img_button = preload("res://Scenes/UnitImgButton.tscn")
var current_units = []
var button_one_unit
var button_two_unit
var minerals: int = 5000

# Called when the node enters the scene tree for the first time.
func _ready():
	minerals_label.text = str(minerals)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rts_controller_units_selected(units):
	current_units = units
	var units_grid = $UnitsGrid
	for n in units_grid.get_children():
		units_grid.remove_child(n)
		n.queue_free()
		
	for i in range(1, len(units)):
		var img_button = unit_img_button.instantiate()
		units_grid.add_child(img_button)
		img_button.texture_normal = units[i].unit_img
		
	main_unit_img.texture = current_units[0].unit_img
	set_button_images()
	
func hide_buttons():
	for button in $SelectionBar/BuildingsGrid.get_children():
		button.visible = false
		
func show_buttons(active_buttons_num):
	hide_buttons()
	for i in range(active_buttons_num):
		$SelectionBar/BuildingsGrid.get_child(i).visible = true


func _on_option_button_one_pressed():
	activate_button(button_one_unit)


func _on_option_button_two_pressed():
	activate_button(button_two_unit)


func set_button_images():
	if current_units[0] is MainBuilding:
		show_buttons(1)
		button_one_unit = WORKER_UNIT
		button_one_img.texture_normal = UNIT_WORKER_IMG
	elif current_units[0] is UnitBuilding:
		show_buttons(1)
		button_one_unit = WARRIOR_UNIT
		button_one_img.texture_normal = UNIT_WARRIOR_IMG
	elif current_units[0] is Worker:
			show_buttons(2)
			button_one_unit = MAIN_BUILDING
			button_one_img.texture_normal = MAIN_BUILDING_IMG
			button_two_unit = UNIT_BUILDNG
			button_two_img.texture_normal = UNIT_BUILDING_IMG
	elif current_units[0] is Warrior:
		show_buttons(0)

func spend_minerals(num):
	minerals -= num
	minerals_label.text = str(minerals)
	
func add_minerals(num):
	minerals += num
	minerals_label.text = str(minerals)


func activate_button(button):
	var unit_button_ins = button.instantiate()
	var selected_unit = current_units[0]
	if unit_button_ins is Building:
		var unit_cost = unit_button_ins.cost
		if minerals >= unit_cost:
			spend_minerals(unit_cost)
			selected_unit.create_stracture(unit_button_ins)
	elif unit_button_ins is Unit:
		var unit_cost = unit_button_ins.cost
		if selected_unit.active:
			if minerals >= unit_cost and selected_unit.current_created_units != selected_unit.max_units:
				spend_minerals(unit_cost)
				selected_unit.add_unit_to_spawn(unit_button_ins)
