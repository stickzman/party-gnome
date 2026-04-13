extends Node2D

@onready var marge := $Marge
@onready var barb := $Barb
@onready var beau := $Beau
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
	barb.chooseIntent()
	beau.chooseIntent()
	marge.chooseIntent()

#resolves the turn by attacking boss, setting move state to false, then having boss attack and setting his attack state to false
func _on_end_turn_button_down() -> void:
	print("ended turn")
	state = GAME_STATE.CONCLUDING_ACTION
	
	for hero in [barb, beau, marge]:
		match hero.intent:
			Hero.INTENT.ATTACK:
				boss.hit(hero.attack)
			Hero.INTENT.HEAL:
				hero.heal()
	
	# Resolve Boss Attacks
	match boss.target:
		boss.TARGETS.ALL:
			for hero in [barb, beau, marge]: hero.hit(boss.attack)
		boss.TARGETS.BEAU:
			beau.hit(boss.attack)
		boss.TARGETS.BARB:
			barb.hit(boss.attack)
		boss.TARGETS.MARGE:
			marge.hit(boss.attack)
		
	state = GAME_STATE.CHOOSING_ACTIONS
	random_moves_phase() # return to random actions phase
