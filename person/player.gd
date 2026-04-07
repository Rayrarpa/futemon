extends CharacterBody2D

const VELOCIDADE = 200

var situationAtual = "idle"


func _process(delta: float) -> void:
	var direction = Input.get_vector("esquerda", "direita", "cima", "baixo")
	
	velocity = direction * VELOCIDADE
	
	if Input.is_action_pressed("sair"):
		get_tree().change_scene_to_file("res://scenes/menu_start.tscn")
	
	if Input.is_action_pressed("direita"):
		situationAtual = "idleL"
		$animaco.play("run")
		$animaco.flip_h = false
	elif Input.is_action_pressed("esquerda"):
		situationAtual = "idleL"
		$animaco.play("run")
		$animaco.flip_h = true
	elif Input.is_action_pressed("cima"):
		situationAtual = "idleC"
		$animaco.flip_h = false
		$animaco.play("runC")
	elif Input.is_action_pressed("baixo"):
		situationAtual = "idle"
		$animaco.flip_h = false
		$animaco.play("runB")
	else:
		$animaco.play(situationAtual)
	
	move_and_slide()
