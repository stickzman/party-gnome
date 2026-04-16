class_name Hand
extends Control

signal potion_created

@export var potentialPotion: Potion = Potion.new()
var selectedCards: Array[Card] = []
@onready var handGrid = $CardSpot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MakePotionButton.disabled = true
	$MakePotionButton.connect("pressed", on_potion_make_button_pressed)
	# Gather ingredients from cards
	var cards = get_tree().get_nodes_in_group("card")
	for c in cards:
		c.selection_changed(on_ingredient_selection_changed)

const CARD_SCENE = preload("res://Nodes/Card.tscn")

func draw_ingredients(ingredients: Array[Ingredient]):
	assert(ingredients.size() <= 5, "hand size max is 5")
	assert(ingredients.size() >= 0, "must draw something")
	for ingredient in ingredients:
		var newCard = CARD_SCENE.instantiate()
		newCard.ingredient = ingredient
		handGrid.add_child(newCard)
		newCard.selection_changed.connect(on_ingredient_selection_changed)

func update_potential_potion():
	self.potentialPotion.ingredients = []
	for c in selectedCards:
		self.potentialPotion.ingredients.append(c.ingredient)
		
	var message = self.potentialPotion.effectBuff.get_message()
	%PotentialPotionStatusLabel.text = message
	
func update_can_make_button():
	print("update can make button")
	$MakePotionButton.disabled = !potentialPotion.canMake()

func on_ingredient_selection_changed(is_selected: bool, card: Card):
	print("on ingredient selction changed. Is selected:", is_selected)
	if is_selected:
		selectedCards.append(card)
	else:
		var i = selectedCards.find(card)
		assert(i != -1, "We should keep track of all cards")
		selectedCards.remove_at(i)
	
	update_potential_potion();
	update_can_make_button();

func on_potion_make_button_pressed():
	print("make potion pressed")
	assert(potentialPotion.canMake(), ">=2 ingredients in potion")
	potion_created.emit(potentialPotion)
	potentialPotion = Potion.new() # reset potion
	
	# Remove ingredient cards as used
	for card in selectedCards:
		card.queue_free() # avoid orphaned nodes
	
	self.selectedCards = [];
	
	# Reset potential potion
	update_potential_potion();
