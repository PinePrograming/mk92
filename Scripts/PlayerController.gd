extends CharacterBody2D

@onready var attack_controller = $AttackController
@onready var anim_player = $AnimatedSprite2D
var is_attacking = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_input = true
@onready var animated_sprite = $AnimatedSprite2D



func _physics_process(delta: float) -> void:
	if is_attacking:
		return #this should skip idle/move anim should I be attacking
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Attack1"):
		$AnimatedSprite2D.play("AttackString1")
		is_attacking = true
	
	

	if not is_attacking:
		if velocity.x != 0:
			$AnimatedSprite2D.play("Walk")
		else:
			$AnimatedSprite2D.play("Idle")
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("Walk")
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("Idle")

	move_and_slide()
	
	
func ready_for_input():
	can_input = true

func _ready():
	attack_controller.initialize(anim_player)
	attack_controller = get_node("AttackController")

func _input(event):
	if event.is_action_pressed("Attack1"):
		if attack_controller and attack_controller.has_method("handle_named_attack"):
			attack_controller.handle_named_attack()
		else:
			print("Error: attack_controller is not set or method handle_named_attack() is missing.")


func _unhandled_input(event):
	if event.is_action_pressed("Attack1"):
		attack_controller.start_attack("Attack1")
		


func _on_AnimatedSprite2D_animation_finished(anim_name):
	if anim_name == "AttackString1":
		is_attacking = false


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
