extends Node2D

#Barbs Base Stat Variables

var barb_max_health = 20
var barb_health = 20
var base_atk = 5 
var base_def = 2
var base_heal = 1

#Barbs Upgradable variables

var atkup = 0
var defup = 0
var healup = 0 

#Barbs Base Stats combined with the changing "upgradable variable" 

var atk = base_atk + atkup
var def = base_def + defup
var heal = base_heal + healup


#Barbs Actions Array

var barb_actions = ["attack", "attack2", "defend", "heal"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D/barbhealth.max_value = barb_max_health
	$AnimatedSprite2D/barbhealth.value = barb_health
	$AnimatedSprite2D/barbhealth/barbhealthlabel.text = str(barb_health) + "/" + str(barb_max_health)
	atkup = 0 
	defup = 0 
	healup = 0 

func update_barb_health():
	$AnimatedSprite2D/barbhealth.value = barb_health
	$AnimatedSprite2D/barbhealth/barbhealthlabel.text = str(barb_health) + "/" + str(barb_max_health)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
