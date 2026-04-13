class_name Hero
extends Node2D

@onready var sprite := $Sprite
@onready var healthBar := $HealthBar
@onready var healthText := $HealthBar/HealthText
@onready var intentText := $IntentText

@export var texture: Texture2D
@export var maxHealth := 20
@export var baseAttack := 5
@export var baseDefense := 2
@export var baseHeal := 1

var health := maxHealth
var healing := 0
var attack := 0
var defense := 0

enum INTENT {ATTACK, DEFEND, HEAL}
var intent: INTENT

func _ready():
	if (texture): sprite.texture = texture
	healthBar.max_value = maxHealth
	healthBar.value = health
	healthText.text = "%s / %s" % [health, maxHealth]
	chooseIntent()

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
			intentText.text = "ATTACK %s" % attack
		INTENT.DEFEND:
			defense = baseDefense
			intentText.text = "DEFEND %s" % defense
		INTENT.HEAL:
			healing = baseHeal
			intentText.text = "HEAL %s" % healing

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
	healthText.text = "%s / %s" % [health, maxHealth]
	if (health <= 0): sprite.flip_v = true

func isDead():
	return health <= 0
