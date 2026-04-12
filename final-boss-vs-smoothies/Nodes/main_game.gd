extends Node2D

#Game States

var choosing_random_actions = false #State for loading final boss action, 3 party members actions and which fruit you draw in this state
var is_picking_fruit = false #state for let you interact with fruit to create potion
var is_picking_potion = false #state that will let you interact with potions to put on characters, might be combined with is_picking_fruit
var concluding_action = false #state that prevents interactions with cards as it conclude the final math


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

#Set Gwim Weeper to Certain Attack State

var boss_attack = false
var boss_wide = false
var boss_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choosing_random_actions = true
	random_moves_phase()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#First phase of the game when the characters and boss moves are randomly chosen
func random_moves_phase():
	if choosing_random_actions == true:
		choose_move_char()
		choose_boss_move()
	choosing_random_actions = false
	
#function to grab from characters arrays and choose what move they are doing
func choose_move_char():
	
	#PICK RANDOM BARB ACTION FROM ACTION ARRAY, SHOWCASE INTENT, PREP MOVE STATE FOR END TURN	
	var barb_action = $barb.barb_actions.pick_random()
	print(barb_action)
	if barb_action == "attack":
		$barb/AnimatedSprite2D/barb_intent.text = "Attack " + str($barb.atk)
		barb_attack = true
	elif barb_action == "attack2":
		$barb/AnimatedSprite2D/barb_intent.text = "Attack " + str($barb.atk)
		barb_attack = true
	elif barb_action == "defend":
		$barb/AnimatedSprite2D/barb_intent.text = "Defend " + str($barb.def)
		barb_defend = true
	elif barb_action == "heal":
		$barb/AnimatedSprite2D/barb_intent.text = "Heal " + str($barb.heal)
		barb_heal = true
	
	#PICK RANDOM BEAU ACTION FROM ACTION ARRAY, SHOWCASE INTENT, PREP MOVE STATE FOR END TURN	
	var beau_action = $beau.beau_actions.pick_random()
	print(beau_action)
	if beau_action == "attack":
		$beau/AnimatedSprite2D/beau_intent.text = "Attack " + str($beau.atk)
		beau_attack = true
	elif beau_action == "attack2":
		$beau/AnimatedSprite2D/beau_intent.text = "Attack " + str($beau.atk)
		beau_attack = true
	elif beau_action == "defend":
		$beau/AnimatedSprite2D/beau_intent.text = "Defend " + str($beau.def)
		beau_defend = true
	elif beau_action == "heal":
		$beau/AnimatedSprite2D/beau_intent.text = "Heal " + str($beau.heal)
		beau_heal = true
	
	#PICK RANDOM MARGE ACTION FROM ACTION ARRAY, SHOWCASE INTENT, PREP MOVE STATE FOR END TURN	
	var marge_action = $marge.marge_actions.pick_random()
	print(marge_action)
	if marge_action == "attack":
		$marge/AnimatedSprite2D/marge_intent.text = "Attack " + str($marge.atk)
		marge_attack = true
	elif marge_action == "attack2":
		$marge/AnimatedSprite2D/marge_intent.text = "Attack " + str($marge.atk)
		marge_attack = true
	elif marge_action == "defend":
		$marge/AnimatedSprite2D/marge_intent.text = "Defend " + str($marge.def)
		marge_defend = true
	elif marge_action == "heal":
		$marge/AnimatedSprite2D/marge_intent.text = "Heal " + str($marge.heal)
		marge_heal = true

#function to grab bosses move choice and output intention 
func choose_boss_move():
	var boss_action = $FinalBoss.boss_attacks.pick_random()
	var boss_target = $FinalBoss.boss_target.pick_random() 
	print(boss_action)
	print(boss_target)
	if boss_action == "b_attack":
		$FinalBoss/Sprite2D/boss_intent.text = "Attack " + str(boss_target) + " for 25"
		boss_attack = true
	elif boss_action == "b_team_attack":
		$FinalBoss/Sprite2D/boss_intent.text = "ALL TEAM 10"
		boss_wide = true	
	

#resolves the turn by attacking boss, setting move state to false, then having boss attack and setting his attack state to false
func _on_end_turn_button_down() -> void:
	if choosing_random_actions == false:
		print("ended turn")
		
		
		# RESOLVE BARB MOVE 
		if barb_attack == true:
			$FinalBoss.boss_health -= $barb.atk
			$FinalBoss.update_health()
			barb_attack = false
		if barb_defend == true: 
			$barb.barb_health += $barb.def
			barb_defend = false
		if barb_heal == true: 
			$barb.barb_health += $barb.heal
			barb_heal = false
		
		#RESOLVE BEAU MOVE
		if barb_attack == true:
			$FinalBoss.boss_health -= $barb.atk
			$FinalBoss.update_health()
			barb_attack = false
		if barb_defend == true: 
			$barb.barb_health += $barb.def
			barb_defend = false
		if barb_heal == true: 
			$barb.barb_health += $barb.heal
			barb_heal = false
		
		#RESOLVE MARGE MOVE
		if barb_attack == true:
			$FinalBoss.boss_health -= $barb.atk
			$FinalBoss.update_health()
			barb_attack = false
		if barb_defend == true: 
			$barb.barb_health += $barb.def
			barb_defend = false
		if barb_heal == true: 
			$barb.barb_health += $barb.heal
			barb_heal = false
		
		
		#RESOLVE BOSS MOVE - TARGETING IS NOT WORKING RIGHT NOW
		if boss_attack == true:
			if boss_target == "barb": 
				$barb.barb_health -= 25
				$barb.update_barb_health()
			elif boss_target == "beau":
				$beau.beau_health -= 25
				$beau.update_beau_health()
			elif boss_target == "marge":
				$marge.marge_health -= 25
				$marge.update_marge_health()
			boss_attack = false
			
		if	boss_wide == true: 
			$barb.barb_health -= 10
			$barb.update_barb_health()
			
			$beau.beau_health -= 10
			$beau.update_beau_health()
			
			$marge.marge_health -= 10
			$marge.update_marge_health()
			
			boss_wide = false
			
	choosing_random_actions = true
	random_moves_phase() #return to random actions phase
