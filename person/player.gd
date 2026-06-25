extends CharacterBody2D
var VELOCIDADE = 200
var situationAtual = "idle"
var title_size = 16
var moving = false
var input_dir
var podeAndar = 1
var matos = []

func _ready():
	randomize()

func entrou_no_mato(mato):
	matos.append(mato)

func saiu_do_mato(mato):
	matos.erase(mato)

func tentar_encontro():
	if matos.is_empty():
		return
	for mato in matos:
		var roll = randi() % 100
		if roll < mato.chance_encontro:
			podeAndar = 0
			SceneTransition.change_scene("res://scenes/battle.tscn")
			return

func _process(delta: float) -> void:
	if Input.is_action_pressed("sair"):
		get_tree().change_scene_to_file("res://scenes/menu_start.tscn")
	if podeAndar == 1:
		if moving:
			return

		input_dir = Vector2.ZERO
		if Input.is_action_pressed("direita"):
			input_dir = Vector2(1,0)
			situationAtual = "idleL"
			$animaco.flip_h = false
			$animaco.play("run")
			move()
		elif Input.is_action_pressed("esquerda"):
			input_dir = Vector2(-1,0)
			situationAtual = "idleL"
			$animaco.flip_h = true
			$animaco.play("run")
			move()
		elif Input.is_action_pressed("cima"):
			input_dir = Vector2(0,-1)
			situationAtual = "idleC"
			$animaco.flip_h = false
			$animaco.play("runC")
			move()
		elif Input.is_action_pressed("baixo"):
			input_dir = Vector2(0,1)
			situationAtual = "idle"
			$animaco.flip_h = false
			$animaco.play("runB")
			move()
		else:
			$animaco.play(situationAtual)
	else:
		$animaco.play("idle")

func move():
	if input_dir != Vector2.ZERO:
		var colisao = move_and_collide(input_dir * title_size, true)
		if colisao:
			moving = false
			return

		moving = true
		var destino = position + input_dir * title_size
		var tween = create_tween()
		tween.tween_property(self, "position", destino, 0.2)
		tween.tween_callback(move_false)
		tentar_encontro()

func move_false():
	moving = false
