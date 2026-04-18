extends Node2D

@onready var marge := $Marge
@onready var barb := $Barb
@onready var beau := $Beau
@onready var boss := $FinalBoss
@onready var potionBelt := %PotionBelt
@onready var hand: Hand = $Hand
@onready var drawPile: DrawPile = $DrawPile
@onready var discardPile: DiscardPile = $DiscardPile
@onready var endTurnBtn := $"End Turn"

# This array should match the order of TARGETS in final_boss.gd
# Yes, this is very hacky but it makes grabbing the target ref easier and it's a game jam,
# so really what do you want from me?
@onready var heroes: Array[Hero] = [barb, marge, beau]

#Game States
enum GAME_STATE {
	IDLE, # Placeholder state to fallback to until the other states are implemented
	CHOOSING_ACTIONS, # State for loading final boss action, 3 party members actions and which fruit you draw in this state
	PICKING_FRUIT, # State for let you interact with fruit to create potion
	PICKING_POTION, # State that will let you interact with potions to put on characters, might be combined with is_picking_fruit
	CONCLUDING_ACTION, # State that prevents interactions with cards as it conclude the final math
}
var state: GAME_STATE = GAME_STATE.IDLE

const HAND_SIZE = 5

var currentPotion = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = GAME_STATE.CHOOSING_ACTIONS
	random_moves_phase()
	# Connect hand to potion belt (what a sentence)
	hand.connect("potion_created", potionBelt.addPotion)
	draw_hand()

	# Connect heroes to PotionBelt
	for hero in heroes: hero.connect("clicked", onCharacterClicked)
	boss.connect("clicked", onCharacterClicked)
	potionBelt.connect("potion_selected", func(potion):
		currentPotion = potion
		for hero in heroes: hero.hoverable = true
		boss.hoverable = true
	)
	potionBelt.connect("potion_deselected", func():
		currentPotion = null
		for hero in heroes: hero.hoverable = false
		boss.hoverable = false
	)

#First phase of the game when the characters and boss moves are randomly chosen
func random_moves_phase():
	if state != GAME_STATE.CHOOSING_ACTIONS: return
	choose_move_char()
	choose_boss_target()
	state = GAME_STATE.IDLE
	
#function to grab from characters arrays and choose what move they are doing
func choose_move_char():
	barb.chooseIntent()
	beau.chooseIntent()
	marge.chooseIntent()

func choose_boss_target():
	var targetIndex = boss.chooseIntent()
	# keep choosing targets until you get a non-dead one
	while targetIndex < heroes.size() and heroes[targetIndex].isDead():
		targetIndex = boss.chooseIntent()

#resolves the turn by attacking boss, setting move state to false, then having boss attack and setting his attack state to false
func _on_end_turn_button_down() -> void:
	discard_rest_of_hand()
	state = GAME_STATE.CONCLUDING_ACTION
	
	# Resolve hero attacks
	for hero in heroes:
		if (hero.isDead()): continue
		if hero.intent == Hero.INTENT.ATTACK: boss.hit(hero.attack)
	
	# Resolve Boss Attacks
	match boss.target:
		FinalBoss.TARGETS.ALL:
			for hero in heroes: hero.hit(boss.attack)
		FinalBoss.TARGETS.BEAU:
			beau.hit(boss.attack)
		FinalBoss.TARGETS.BARB:
			barb.hit(boss.attack)
		FinalBoss.TARGETS.MARGE:
			marge.hit(boss.attack)

	for hero in heroes: hero.endOfTurn()
	boss.endOfTurn()

	if boss.isDead():
		%WinMessage.visible = true
		endTurnBtn.disabled = true
		return
	elif heroes.all(func(hero): return hero.isDead()):
		%LoseMessage.visible = true
		endTurnBtn.disabled = true
		return


	state = GAME_STATE.CHOOSING_ACTIONS
	random_moves_phase() # return to random actions phase
	draw_hand()
	
func discard_rest_of_hand():
	# OOP actually works wow
	discardPile.add(hand.discard_remaining())
	
	
# Draw cards, shuffle the discard and move to draw pile if necessary
# Then keep drawing until HAND_SIZE.
func draw_hand():
	print("drawing hand")
	var ingredients_hand: Array[Ingredient] = drawPile.try_draw_n(HAND_SIZE)
	
	print("hand size", ingredients_hand.size())
	if (ingredients_hand.size() < HAND_SIZE):
		print("triggering xfer")
		assert(drawPile.pile.size() == 0, "draw pile should be empty to trigger discard xfer")
		var out = discardPile.transfer_out()
			
		drawPile.shuffle_in(out)
		print("draw pile shuffled in")
		
		# True up to the HAND size after shuffling in the discard
		var remaining = min(HAND_SIZE - ingredients_hand.size(), drawPile.pile.size())
		print("need to draw this many more", HAND_SIZE)
		for _i in range(0, remaining):
			print("drawing true up card from pile")
			ingredients_hand.append(drawPile.draw_card())
	
	assert(ingredients_hand.size() <= HAND_SIZE, "should be at most hand size")
	hand.grab(ingredients_hand)

func onCharacterClicked(character):
	if currentPotion == null || character.drankPotion: return
	character.drinkPotion(currentPotion)
	potionBelt.removePotion(currentPotion)
	discardPile.release_ingredients_in_potion(currentPotion)
	currentPotion = null
	for hero in heroes: hero.hoverable = false
	boss.hoverable = false
