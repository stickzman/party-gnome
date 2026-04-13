extends Node2D

@onready var hero := $Hero
@onready var boss := $FinalBoss

#Game States
enum GAME_STATE {
	IDLE, # Placeholder state to fallback to until the other states are implemented
	CHOOSING_ACTIONS, # State for loading final boss action, 3 party members actions and which fruit you draw in this state
	PICKING_FRUIT, # State for let you interact with fruit to create potion
	PICKING_POTION, # State that will let you interact with potions to put on characters, might be combined with is_picking_fruit
	CONCLUDING_ACTION, # State that prevents interactions with cards as it conclude the final math
}
var state: GAME_STATE = GAME_STATE.IDLE


# Characters Move State Switch

var barb_attack = false
var barb_defend = false
var barb_heal = false

var beau_attack = false
var beau_defend = false
var beau_heal = false

var marge_attack = false
var marge_defend = false
var marge_heal = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = GAME_STATE.CHOOSING_ACTIONS
	random_moves_phase()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#First phase of the game when the characters and boss moves are randomly chosen
func random_moves_phase():
	if state != GAME_STATE.CHOOSING_ACTIONS: return
	choose_move_char()
	boss.chooseIntent()
	state = GAME_STATE.IDLE
	
#function to grab from characters arrays and choose what move they are doing
func choose_move_char():
	hero.chooseIntent()
	# #PICK RANDOM BARB ACTION FROM ACTION ARRAY, SHOWCASE INTENT, PREP MOVE STATE FOR END TURN	
	# var barb_action = $barb.barb_actions.pick_random()
	# if barb_action == "attack":
	# 	$barb/AnimatedSprite2D/barb_intent.text = "Attack " + str($barb.atk)
	# 	barb_attack = true
	# elif barb_action == "attack2":
	# 	$barb/AnimatedSprite2D/barb_intent.text = "Attack " + str($barb.atk)
	# 	barb_attack = true
	# elif barb_action == "defend":
	# 	$barb/AnimatedSprite2D/barb_intent.text = "Defend " + str($barb.def)
	# 	barb_defend = true
	# elif barb_action == "heal":
	# 	$barb/AnimatedSprite2D/barb_intent.text = "Heal " + str($barb.heal)
	# 	barb_heal = true
	
	# #PICK RANDOM BEAU ACTION FROM ACTION ARRAY, SHOWCASE INTENT, PREP MOVE STATE FOR END TURN	
	# var beau_action = $beau.beau_actions.pick_random()
	# if beau_action == "attack":
	# 	$beau/AnimatedSprite2D/beau_intent.text = "Attack " + str($beau.atk)
	# 	beau_attack = true
	# elif beau_action == "attack2":
	# 	$beau/AnimatedSprite2D/beau_intent.text = "Attack " + str($beau.atk)
	# 	beau_attack = true
	# elif beau_action == "defend":
	# 	$beau/AnimatedSprite2D/beau_intent.text = "Defend " + str($beau.def)
	# 	beau_defend = true
	# elif beau_action == "heal":
	# 	$beau/AnimatedSprite2D/beau_intent.text = "Heal " + str($beau.heal)
	# 	beau_heal = true
	
	# #PICK RANDOM MARGE ACTION FROM ACTION ARRAY, SHOWCASE INTENT, PREP MOVE STATE FOR END TURN	
	# var marge_action = $marge.marge_actions.pick_random()
	# if marge_action == "attack":
	# 	$marge/AnimatedSprite2D/marge_intent.text = "Attack " + str($marge.atk)
	# 	marge_attack = true
	# elif marge_action == "attack2":
	# 	$marge/AnimatedSprite2D/marge_intent.text = "Attack " + str($marge.atk)
	# 	marge_attack = true
	# elif marge_action == "defend":
	# 	$marge/AnimatedSprite2D/marge_intent.text = "Defend " + str($marge.def)
	# 	marge_defend = true
	# elif marge_action == "heal":
	# 	$marge/AnimatedSprite2D/marge_intent.text = "Heal " + str($marge.heal)
	# 	marge_heal = true
	

#resolves the turn by attacking boss, setting move state to false, then having boss attack and setting his attack state to false
func _on_end_turn_button_down() -> void:
	print("ended turn")
	state = GAME_STATE.CONCLUDING_ACTION
	
	match hero.intent:
		Hero.INTENT.ATTACK:
			boss.hit(hero.attack)
		Hero.INTENT.HEAL:
			hero.heal()

	# # RESOLVE BARB MOVE 
	# if barb_attack == true:
	# 	$FinalBoss.boss_health -= $barb.atk
	# 	$FinalBoss.update_health()
	# 	barb_attack = false
	# if barb_defend == true:
	# 	$barb.barb_health += $barb.def
	# 	barb_defend = false
	# if barb_heal == true:
	# 	$barb.barb_health += $barb.heal
	# 	barb_heal = false
	
	# #RESOLVE BEAU MOVE
	# if barb_attack == true:
	# 	$FinalBoss.boss_health -= $barb.atk
	# 	$FinalBoss.update_health()
	# 	barb_attack = false
	# if barb_defend == true:
	# 	$barb.barb_health += $barb.def
	# 	barb_defend = false
	# if barb_heal == true:
	# 	$barb.barb_health += $barb.heal
	# 	barb_heal = false
	
	# #RESOLVE MARGE MOVE
	# if barb_attack == true:
	# 	$FinalBoss.boss_health -= $barb.atk
	# 	$FinalBoss.update_health()
	# 	barb_attack = false
	# if barb_defend == true:
	# 	$barb.barb_health += $barb.def
	# 	barb_defend = false
	# if barb_heal == true:
	# 	$barb.barb_health += $barb.heal
	# 	barb_heal = false
	
	
	# Resolve Boss Attacks
	match boss.target:
		boss.TARGETS.ALL:
			hero.hit(boss.attack)
			# TODO: Add remaining heroes
		
	state = GAME_STATE.CHOOSING_ACTIONS
	random_moves_phase() # return to random actions phase
