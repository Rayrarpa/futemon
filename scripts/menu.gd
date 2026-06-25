extends CanvasLayer
@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control
enum ScreenLoaded {NOTHING, JUST_MENU, PARTY_SCREEN }
var screen_loaded = ScreenLoaded.NOTHING
var selected_option: int = 0
var inv_selected: int = 0

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
				select_arrow.position.y = 5

		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu") or event.is_action_pressed("voltar"):
				var player = get_tree().get_first_node_in_group("player")
				player.set_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
				selected_option = 0
			elif event.is_action_pressed("ataque") and select_arrow.position.y == 82:
				var inventory = get_tree().get_first_node_in_group("Inventory")
				inventory.get_node("Control").visible = true
				inv_selected = 0
				var arrow_inv = inventory.get_node("Control/NinePatchRect/TextureRect")
				arrow_inv.position = Vector2(0, 0)
				screen_loaded = ScreenLoaded.PARTY_SCREEN
			elif event.is_action_pressed("down"):
				selected_option += 1
				select_arrow.position.y = 5 + (selected_option % 5) * 77
				print(select_arrow.position.y)
			elif event.is_action_pressed("up"):
				if selected_option == 0:
					selected_option = 5
				else:
					selected_option -= 1
				select_arrow.position.y = 5 + (selected_option % 5) * 77

		ScreenLoaded.PARTY_SCREEN:
			var inventory = get_tree().get_first_node_in_group("Inventory")
			inventory.get_node("Control").visible = true
			select_arrow.visible = false
			var arrow_inv = inventory.get_node("Control/NinePatchRect/TextureRect")

			const COLS = 4
			const ROWS = 4
			const CELL_SIZE = 54

			if event.is_action_pressed("down"):
				inv_selected = (inv_selected + COLS) % (COLS * ROWS)
			elif event.is_action_pressed("up"):
				inv_selected = (inv_selected - COLS + COLS * ROWS) % (COLS * ROWS)
			elif event.is_action_pressed("right"):
				var row = inv_selected / COLS
				var col = (inv_selected % COLS + 1) % COLS
				inv_selected = row * COLS + col
			elif event.is_action_pressed("left"):
				var row = inv_selected / COLS
				var col = (inv_selected % COLS - 1 + COLS) % COLS
				inv_selected = row * COLS + col
			elif event.is_action_pressed("voltar"):
				inventory.get_node("Control").visible = false
				select_arrow.visible = true
				inv_selected = 0
				screen_loaded = ScreenLoaded.JUST_MENU

			arrow_inv.position.x = 8 + (inv_selected % COLS) * CELL_SIZE
			arrow_inv.position.y = 9 + (inv_selected / COLS) * CELL_SIZE
