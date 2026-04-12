extends Node2D

#Boss Base Stats

var boss_health = 100
var boss_max_health = 100
var boss_attacks = ["b_attack", "b_team_attack"]
var boss_target = ["barb", "beau", "marge"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D/bosshealth.max_value = boss_max_health
	$Sprite2D/bosshealth.value = boss_health
	$Sprite2D/bosshealth/Label.text = str(boss_health) + "/" + str(boss_max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health() -> void:
	$Sprite2D/bosshealth.value = boss_health
	$Sprite2D/bosshealth/Label.text = str(boss_health) + "/" + str(boss_max_health)
