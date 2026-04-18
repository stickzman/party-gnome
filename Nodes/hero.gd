class_name Hero
extends Node2D

signal clicked

@onready var sprite := $Sprite
@onready var highlightSprite := $Highlight
@onready var healthBar := $HealthBar
@onready var healthLabel := $HealthBar/HealthText
@onready var intentLabel := $IntentText
@onready var nameLabel := $NameText
@onready var clickTarget := $ClickTarget
@onready var animPlayer := $AnimationPlayer

@export var maxHealth := 15
@export var baseAttack := 5
@export var baseDefense := 2
@export var baseHeal := 1

@onready var health := maxHealth
var healing := 0
var attack := 0
var defense := 0
const maxDefense = 9999

enum INTENT {ATTACK, DEFEND, HEAL}
var intent

var drankPotion := false

var _hoverable := false
var hoverable: bool:
	get: return _hoverable && !drankPotion
	set(value):
		highlightSprite.visible = false
		_hoverable = value

func _ready():
	clickTarget.connect("input_event", func(_viewport: Node, event: InputEvent, _shape_idx: int):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT: clicked.emit(self )
	)
	clickTarget.connect("mouse_entered", func(): if hoverable: highlightSprite.visible = true)
	clickTarget.connect("mouse_exited", func(): if hoverable: highlightSprite.visible = false)
	highlightSprite.texture = sprite.texture
	nameLabel.text = name
	healthBar.max_value = maxHealth
	healthBar.value = health
	healthLabel.text = "%s / %s" % [health, maxHealth]

func endOfTurn():
	# Heal at end of turn, after receiving dmg
	if !isDead() && intent == INTENT.HEAL: heal()
	# Reset statuses
	healing = 0
	defense = 0
	attack = 0
	drankPotion = false

func chooseIntent():
	if isDead(): return
	intent = randi() % INTENT.size() as INTENT
	# Reset stat to base scores if using ability
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
	if defense == maxDefense: intentLabel.text += "\nIMMUNE from damage this turn!"

func attackAnim():
	animPlayer.play("attack")
	await animPlayer.animation_finished

# Reduce incoming damage by defense, then return the remaining damage
func defend(damage: int):
	defense -= damage
	var remainingDamage = 0 if defense >= 0 else abs(defense)
	defense = 0 # Reset defense to 0
	return remainingDamage

func hit(damage: int):
	if intent == Hero.INTENT.DEFEND || defense == maxDefense:
		var remainingDamage = defend(damage)
		updateHealth(-remainingDamage)
	else:
		updateHealth(-damage)

func heal():
	updateHealth(healing)

func updateHealth(amount: int):
	if amount < 0: animPlayer.play("hurt")
	health += amount
	health = clampi(health, 0, maxHealth) # Clamp health to 0-maxHealth
	healthBar.value = health
	healthLabel.text = "%s / %s" % [health, maxHealth]
	if (health <= 0):
		if amount < 0: await animPlayer.animation_finished
		sprite.flip_v = true
		highlightSprite.flip_v = true
		intent = null
		updateIntentDisplay()
	else:
		sprite.flip_v = false
		highlightSprite.flip_v = false

func isDead():
	return health <= 0

func drinkPotion(potion: Potion):
	if drankPotion: return
	drankPotion = true
	var effectBuff = potion.effectBuff
	attack += effectBuff.attackValueModifier
	attack *= effectBuff.attackMultModifier + 1
	defense += effectBuff.defenseValueModifier
	if effectBuff.hasImmunity: defense = maxDefense

	if effectBuff.doesRevive && isDead():
		# Heal to revive
		updateHealth(effectBuff.healthValueModifier)
	else:
		healing += effectBuff.healthValueModifier

	updateIntentDisplay()