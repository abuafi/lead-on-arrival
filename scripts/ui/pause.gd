extends Control
class_name Pause

@onready var unpause_button: Button = $PanelContainer/VBoxContainer/Continue
@onready var return_to_menu_button: Button = $PanelContainer/VBoxContainer/Menu

var ui: GameUI

func _ready():
    unpause_button.pressed.connect(unpause)
    return_to_menu_button.pressed.connect(return_to_menu)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"pause"):
        get_tree().get_root().set_input_as_handled()
        unpause()

func unpause():
    hide()
    get_tree().paused = false

func return_to_menu():
    var new_ui = GameUI.UI_SCENE.instantiate()
    var root: Node = ui.get_parent()
    root.remove_child(ui)
    root.add_child(new_ui)
    ui.queue_free()
    root.get_tree().paused = false