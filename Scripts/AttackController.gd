#AttackController.gd	
extends Node

class_name AttackController



var anim_player: AnimationPlayer
var queued_attack = "" 
var attacking_in_progress = false
var combo_timer: Timer

signal combo_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	combo_timer = Timer.new()
	combo_timer.wait_time = 0.4
	combo_timer.one_shot = true
	combo_timer.connect("timeout", Callable(self, "_on_combo_timeout"))
	call_deferred("add_child", combo_timer)
	

func initialize(_anim_player: AnimationPlayer):
	anim_player = _anim_player
	anim_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	

func handle_named_attack(anim_name: String):
	if not attacking_in_progress:
		start_attack(anim_name)
	elif combo_timer.time_left > 0.0:
		queue_attack(anim_name)
		


func start_attack(anim_name: String):
	attacking_in_progress = true
	queued_attack = ""
	play_attack_animation(anim_name)
	combo_timer.start()

func queue_attack(anim_name: String):
	queued_attack = anim_name
	combo_timer.start()


func play_attack_animation(anim_name: String):
	if anim_player.has_animation(anim_name):
		anim_player.play(anim_name)


func _on_combo_timeout():
	attacking_in_progress = false
	queued_attack = ""
	emit_signal("combo_ended")
	

func _on_animation_finished(anim_name):
	if anim_name.begins_with("attackstring"):
		if queued_attack != "":
			play_attack_animation(queued_attack)
			queued_attack = ""
			combo_timer.start()
		else:
			attacking_in_progress = false
				

 
