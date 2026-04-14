class_name FinalBoss
extends Node2D

signal clicked

@onready var sprite := $Sprite2D
@onready var healthBar := $HealthBar
@onready var healthText := $HealthBar/HealthText
@onready var intentText := $IntentText
@onready var clickTarget := $Area2D

#Boss Base Stats
@export var maxAttack := 25
var attack := 0
var maxHealth := 100
var health := maxHealth

enum TARGETS {BARB, MARGE, BEAU, ALL}
var target: TARGETS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clickTarget.connect("input_event", func(_viewport: Node, event: InputEvent, _shape_idx: int):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT: clicked.emit(self )
	)
	healthBar.max_value = maxHealth
	healthBar.value = health
	healthText.text = "%s / %s" % [health, maxHealth]
	chooseIntent()

func chooseIntent():
	target = randi() % TARGETS.size() as TARGETS
	attack = randi_range(3, maxAttack)
	if target == TARGETS.ALL: attack /= 3 # If attacking all heroes, reduce the damage appropiately
	intentText.text = "Attacking %s for %s damage" % [TARGETS.keys()[target], attack]
	return target

func hit(damage: int):
	updateHealth(-damage)

func updateHealth(amount: int):
	health += amount
	health = clampi(health, 0, maxHealth) # Clamp health to 0-maxHealth
	healthBar.value = health
	healthText.text = "%s / %s" % [health, maxHealth]
	if (health <= 0):
		sprite.flip_v = true
		intentText.text = ""
