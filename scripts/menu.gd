extends CanvasLayer

@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control


enum ScreenLoaded {NOTHING, JUST_MENU, PARTY_SCREEN }
var screen_loaded = ScreenLoaded.NOTHING

var selected_option: int = 0

func _ready() -> void:
	menu.visible = false
	select_arrow.position.y = 18 + (selected_option % 5) * 77

func _unhandled_input(event):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				var player = get_tree().get_first_node_in_group("player")
				
				if !player.moving:
					player.set_process(false)
					menu.visible = true
					screen_loaded = ScreenLoaded.JUST_MENU
				menu.visible = true
				screen_loaded = ScreenLoaded.JUST_MENU
				selected_option = 0
				select_arrow.position.y = 10
				
		
		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("ataque") or event.is_action_pressed("menu"):
				var player = get_tree().get_first_node_in_group("player")
				player.set_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
				selected_option = 0
			elif event.is_action_pressed("down"):
				selected_option += 1
				select_arrow.position.y = 5 + (selected_option % 5) * 77
			elif event.is_action_pressed("up"):
				if selected_option == 0:
					selected_option = 5
				else:
					selected_option -= 1
				select_arrow.position.y = 5 + (selected_option % 5) * 77
		
		ScreenLoaded.PARTY_SCREEN:
			select_arrow.visible = false
			var inventory = get_tree().get_first_node_in_group("Inventory")
			inventory.get_node("Control").visible = true
