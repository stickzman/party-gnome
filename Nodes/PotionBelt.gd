extends PanelContainer

@onready var firstPotionBtn := %FirstPotionBtn
@onready var firstPotionLabel := %FirstPotionLabel
@onready var secondPotionBtn := %SecondPotionBtn
@onready var secondPotionLabel := %SecondPotionLabel

var firstPotion: Potion
var secondPotion: Potion

const USE_TEXT := "Use Potion"
const USING_TEXT := "Using..."
const EMPTY_TEXT := "(empty)"

signal potion_selected
signal potion_deselected

func _ready() -> void:
    firstPotionBtn.connect("pressed", toggleFirstPotion)
    secondPotionBtn.connect("pressed", toggleSecondPotion)

func addPotion(potion: Potion):
    if !firstPotion:
        firstPotion = potion
        firstPotionBtn.disabled = false
        firstPotionLabel.text = potion.effectBuff.get_message()
    elif !secondPotion:
        secondPotion = potion
        secondPotionBtn.disabled = false
        secondPotionLabel.text = potion.effectBuff.get_message()
    else:
        print("can't add more potions, we're full")

func removePotion(potion: Potion):
    if firstPotion == potion:
        firstPotion = null
        firstPotionBtn.disabled = true
        if secondPotion: secondPotionBtn.disabled = false
        firstPotionBtn.text = USE_TEXT
        firstPotionLabel.text = EMPTY_TEXT
    elif secondPotion == potion:
        secondPotion = null
        secondPotionBtn.disabled = true
        if firstPotion: firstPotionBtn.disabled = false
        secondPotionBtn.text = USE_TEXT
        secondPotionLabel.text = EMPTY_TEXT
    else:
        printerr("Attempted to remove Potion %s that isn't in PotionBelt" % potion)


func toggleFirstPotion():
    if firstPotionBtn.text == USING_TEXT:
        # Toggle off
        firstPotionBtn.text = USE_TEXT
        if secondPotion: secondPotionBtn.disabled = false
        potion_deselected.emit()
    else:
        # Toggle on
        firstPotionBtn.text = USING_TEXT
        secondPotionBtn.disabled = true
        potion_selected.emit(firstPotion)

func toggleSecondPotion():
    if secondPotionBtn.text == USING_TEXT:
        # Toggle off
        secondPotionBtn.text = USE_TEXT
        firstPotionBtn.disabled = false
        potion_deselected.emit()
    else:
        # Toggle on
        secondPotionBtn.text = USING_TEXT
        if firstPotion: firstPotionBtn.disabled = true
        potion_selected.emit(secondPotion)
