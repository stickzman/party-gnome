extends Node2D


#Beau Base Stat Variables

var beau_max_health = 15
var beau_health = 15
var base_atk = 5 
var base_def = 2
var base_heal = 1

#Beau Upgradable variables

var atkup = 0
var defup = 0
var healup = 0 

#Beaus Base Stats combined with the changing "upgradable variable" 

var atk = base_atk + atkup
var def = base_def + defup
var heal = base_heal + healup


#Barbs Actions Array

var beau_actions = ["attack", "attack2", "defend", "heal"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D/beauhealth.max_value = beau_max_health
	$AnimatedSprite2D/beauhealth.value = beau_health
	$AnimatedSprite2D/beauhealth/beauhealthlabel.text = str(beau_health) + "/" + str(beau_max_health)
	atkup = 0 
	defup = 0 
	healup = 0 

func update_beau_health():
	$AnimatedSprite2D/beauhealth.value = beau_health
	$AnimatedSprite2D/beauhealth/beauhealthlabel.text = str(beau_health) + "/" + str(beau_max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
