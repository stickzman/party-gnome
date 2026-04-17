class_name DiscardPile
extends Control

@onready var discardPileCountLabel = $DiscardPileCountLabel

var pile: Array[Ingredient] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateDiscardPileCountLabel()

func add(ingredients: Array[Ingredient]):
	for ingredient in ingredients:
		pile.append(ingredient)
	updateDiscardPileCountLabel()
	
func transfer_out() -> Array[Ingredient]:
	var out = pile.duplicate(true)
	pile = []
	updateDiscardPileCountLabel()
	return out
	
func updateDiscardPileCountLabel():
	# TODO: have this scene shake or highlight or something to let player know it's been updated
	discardPileCountLabel.text = str(pile.size())
	
func release_ingredients_in_potion(potion: Potion):
	for ingredient in potion.ingredients:
		pile.append(ingredient)
		
	updateDiscardPileCountLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
