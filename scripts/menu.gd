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
				menu.visible = true
				screen_loaded = ScreenLoaded.JUST_MENU
		
		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("ataque") or event.is_action_pressed("menu"):
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
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
			pass
