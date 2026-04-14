class_name Hero
extends Node2D

signal hero_clicked

@onready var sprite := $Sprite
@onready var healthBar := $HealthBar
@onready var healthLabel := $HealthBar/HealthText
@onready var intentLabel := $IntentText
@onready var nameLabel := $NameText

@export var maxHealth := 15
@export var baseAttack := 5
@export var baseDefense := 2
@export var baseHeal := 1

@onready var health := maxHealth
var healing := 0
var attack := 0
var defense := 0

enum INTENT {ATTACK, DEFEND, HEAL}
var intent

func _ready():
	nameLabel.text = name
	healthBar.max_value = maxHealth
	healthBar.value = health
	healthLabel.text = "%s / %s" % [health, maxHealth]

func chooseIntent():
	if isDead(): return
	intent = randi() % INTENT.size() as INTENT
	# Reset all stats for this turn, use base scores if using ability, set to 0 otherwise
	healing = 0
	defense = 0
	attack = 0
	match intent:
		INTENT.ATTACK:
			attack = baseAttack
		INTENT.DEFEND:
			defense = baseDefense
		INTENT.HEAL:
			healing = baseHeal
	updateIntentDisplay()

func updateIntentDisplay():
	match intent:
		INTENT.ATTACK:
			intentLabel.text = "ATTACK %s" % attack
		INTENT.DEFEND:
			intentLabel.text = "DEFEND %s" % defense
		INTENT.HEAL:
			intentLabel.text = "HEAL %s" % healing
		_:
			intentLabel.text = ""

# Reduce incoming damage by defense, then return the remaining damage
func defend(damage: int):
	defense -= damage
	var remainingDamage = 0 if defense >= 0 else abs(defense)
	defense = 0 # Reset defense to 0
	return remainingDamage

func hit(damage: int):
	var remainingDamage = defend(damage)
	updateHealth(-remainingDamage)

func heal():
	updateHealth(healing)

func updateHealth(amount: int):
	health += amount
	health = clampi(health, 0, maxHealth) # Clamp health to 0-maxHealth
	healthBar.value = health
	healthLabel.text = "%s / %s" % [health, maxHealth]
	if (health <= 0):
		sprite.flip_v = true
		intent = null
		updateIntentDisplay()
	else:
		sprite.flip_v = false

func isDead():
	return health <= 0

func drinkPotion(potion: Potion):
	var effectBuff = potion.effectBuff
	attack += effectBuff.attackValueModifier
	attack *= effectBuff.attackMultModifier + 1
	defense += effectBuff.defenseValueModifier
	healing += effectBuff.healthValueModifier

	if effectBuff.hasImmunity: defense = 9999 # INF only works as a floating-point number, so I'm harding coding this max DEF
	if effectBuff.doesRevive && isDead(): updateHealth(1) # Heal 1hp to revive
	
	updateIntentDisplay()


func _on_click_target_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		hero_clicked.emit(self )