extends CanvasLayer

@onready var window_mode_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowModeButton
@onready var resolution_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResolutionButton
@onready var master_slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MasterSlider
@onready var music_slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicSlider
@onready var effects_slider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/EffectsSlider

var window_modes : Dictionary = {
	"Windowed" : DisplayServer.WINDOW_MODE_WINDOWED,
	"Maximized" : DisplayServer.WINDOW_MODE_MAXIMIZED,
	"Fullscreen" : DisplayServer.WINDOW_MODE_FULLSCREEN,
	"Exclusive Fullscreen" : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
}
var resolutions : Dictionary = {
	#"320x180" : Vector2i(320, 180),
	"480x270" : Vector2i(480, 270),
	#"640x360" : Vector2i(960, 540),
	#"1440x810" : Vector2i(1440, 810),
	#"1920x1080" : Vector2i(1920, 1080),
}

var master_volume : float = 0.0
var music_volume : float = 0.0
var effects_volume : float = 0.0


func _ready():
	for window_mode in window_modes:
		window_mode_button.add_item(window_mode)
	for resolution in resolutions:
		resolution_button.add_item(resolution)
	initialize_controls()

func initialize_controls():
	SettingsManager.load_settings()
	var settings_data : SettingsDataResource = SettingsManager.get_settings_data()
	window_mode_button.selected = settings_data.window_mode_index
	resolution_button.selected = settings_data.resolution_index
	master_slider.value = settings_data.master_volume
	music_slider.value = settings_data.music_volume
	effects_slider.value = settings_data.effects_volume

func _on_window_mode_button_item_selected(index):
	var window_mode = window_modes.get(window_mode_button.get_item_text(index)) as int
	SettingsManager.set_window_mode(window_mode, index)


func _on_resolution_button_item_selected(index):
	var resolution = resolutions.get(resolution_button.get_item_text(index)) as Vector2i
	SettingsManager.set_resolution(resolution, index)


func _on_master_slider_value_changed(value):
	master_volume = value
	SettingsManager.set_master_volume(value)

func _on_music_slider_value_changed(value):
	music_volume = value
	SettingsManager.set_music_volume(value)

func _on_effects_slider_value_changed(value):
	effects_volume = value
	SettingsManager.set_effects_volume(value)
	
func _on_main_menu_button_pressed():
	SettingsManager.save_settings()
	GameManager.main_menu_screen()
	queue_free()
