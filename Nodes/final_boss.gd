class_name FinalBoss
extends Node2D

signal clicked

@onready var sprite := $Sprite2D
@onready var highlightSprite := $Highlight
@onready var healthBar := $HealthBar
@onready var healthText := $HealthBar/HealthText
@onready var intentText := $IntentText
@onready var clickTarget := $Area2D

var drankPotion := false

var _hoverable := false
var hoverable: bool:
	get: return _hoverable && !drankPotion
	set(value):
		highlightSprite.visible = false
		_hoverable = value

#Boss Base Stats
@export var maxAttack := 25
var attack := 0
var defense := 0 # Only applicable if the player uses a DEF potion on the FinalBoss
const maxDefense := 9999
var healing := 0 # Only applicable if the player uses a HEAL potion on the FinalBoss
var maxHealth := 1
var health := maxHealth

enum TARGETS {BARB, MARGE, BEAU, ALL}
var target: TARGETS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clickTarget.connect("input_event", func(_viewport: Node, event: InputEvent, _shape_idx: int):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT: clicked.emit(self )
	)
	clickTarget.connect("mouse_entered", func(): if hoverable: highlightSprite.visible = true)
	clickTarget.connect("mouse_exited", func(): if hoverable: highlightSprite.visible = false)
	healthBar.max_value = maxHealth
	healthBar.value = health
	healthText.text = "%s / %s" % [health, maxHealth]
	chooseIntent()

func chooseIntent():
	if (isDead()): return
	target = randi() % TARGETS.size() as TARGETS
	attack = randi_range(3, maxAttack)
	if target == TARGETS.ALL: attack /= 3 # If attacking all heroes, reduce the damage appropiately
	updateIntentDisplay()
	return target

# Reduce incoming damage by defense, then return the remaining damage
func defend(damage: int):
	defense -= damage
	var remainingDamage = 0 if defense >= 0 else abs(defense)
	defense = 0 # Reset defense to 0
	return remainingDamage

func hit(damage: int):
	var remainingDamage = defend(damage)
	updateHealth(-remainingDamage)

func updateHealth(amount: int):
	health += amount
	health = clampi(health, 0, maxHealth) # Clamp health to 0-maxHealth
	healthBar.value = health
	healthText.text = "%s / %s" % [health, maxHealth]
	if (isDead()):
		sprite.flip_v = true
		updateIntentDisplay()

func drinkPotion(potion: Potion):
	if drankPotion: return
	drankPotion = true
	var effectBuff = potion.effectBuff
	attack += effectBuff.attackValueModifier
	attack *= effectBuff.attackMultModifier + 1
	defense += effectBuff.defenseValueModifier
	healing += effectBuff.healthValueModifier

	if effectBuff.hasImmunity: defense = maxDefense
	updateIntentDisplay()

func endOfTurn():
	updateHealth(healing)
	drankPotion = false
	healing = 0
	defense = 0
	updateIntentDisplay()

func updateIntentDisplay():
	intentText.text = "" # Clear display to start, cause they might be dead
	if isDead(): return
	intentText.text = "Attacking %s for %s damage" % [TARGETS.keys()[target], attack]
	if defense > 0: intentText.text += "\nDefending for %s" % defense
	if healing > 0: intentText.text += "\nHealing for %s" % healing

func isDead():
	return health <= 0