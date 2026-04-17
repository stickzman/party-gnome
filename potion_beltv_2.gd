extends PanelContainer

@onready var firstPotionBtn := %FirstPotionBtn
@onready var firstPotionLabel := %FirstPotionLabel
@onready var secondPotionBtn := %SecondPotionBtn
@onready var secondPotionLabel := %SecondPotionLabel

var firstPotion: Potion
var secondPotion: Potion

const USE_TEXT := "Use Potion"
const USING_TEXT := "Using..."

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
        firstPotionLabel.text = USE_TEXT
    elif secondPotion == potion:
        secondPotion = null
        secondPotionBtn.disabled = true
        secondPotionLabel.text = USE_TEXT
    else:
        printerr("Attempted to remove Potion %s that isn't in PotionBelt" % potion)


func toggleFirstPotion():
    if secondPotionBtn.disabled:
        # Toggle off
        firstPotionBtn.text = USE_TEXT
        secondPotionBtn.disabled = false
        potion_deselected.emit()
    else:
        # Toggle on
        firstPotionBtn.text = USING_TEXT
        secondPotionBtn.disabled = true
        potion_selected.emit(firstPotion)

func toggleSecondPotion():
    if firstPotionBtn.disabled:
        # Toggle off
        secondPotionBtn.text = USE_TEXT
        firstPotionBtn.disabled = false
        potion_deselected.emit()
    else:
        # Toggle on
        secondPotionBtn.text = USING_TEXT
        firstPotionBtn.disabled = true
        potion_selected.emit(secondPotion)
