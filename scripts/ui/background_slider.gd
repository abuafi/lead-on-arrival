extends Slider

@onready var background: Background = $"/root/Ui/SubViewportContainer/SubViewport/Background"

func _ready():
    load_data()
    drag_ended.connect(_on_drag_ended)

func _on_drag_ended(_value_changed: bool):
    if not _value_changed: return
    background.scrolling_speed = value
    save_data()

func save_data():
    var saved_options: Dictionary
    var save_file: FileAccess = FileAccess.open("user://options.json", FileAccess.READ)
    if is_instance_valid(save_file):
        var _text: String = save_file.get_as_text()
        save_file.close()
        saved_options = JSON.parse_string(_text)
    if not saved_options: saved_options = {}
    saved_options['bg_scroll'] = value
    var json_string: String = JSON.stringify(saved_options)

    save_file = FileAccess.open("user://options.json", FileAccess.WRITE)
    save_file.store_line(json_string)
    save_file.close()
    
func load_data():
    var save_file: FileAccess = FileAccess.open("user://options.json", FileAccess.READ)
    if not is_instance_valid(save_file): return
    var _text: String = save_file.get_as_text()
    var saved_options = JSON.parse_string(_text)
    var keys: Array = saved_options.keys()

    if not saved_options: 
        save_file.close()
        return
    if 'bg_scroll' not in keys: 
        save_file.close()
        return

    value = saved_options['bg_scroll'] 
    background.scrolling_speed = value
    save_file.close()
