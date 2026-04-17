extends Node2D

@onready var ingredientBag = $IngredientBag

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addIngredient(ingredient: Ingredient) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = ingredient.sprite
	sprite.scale = Vector2(0.15, 0.15)
	$IngredientBag.add_child(sprite)
