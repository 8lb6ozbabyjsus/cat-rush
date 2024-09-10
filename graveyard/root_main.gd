extends Control

# Enum to keep track of the current menu state
enum MenuState {
	MAIN_MENU,
	OPTIONS_MENU,
	GAME_SCREEN  # For transitioning to the game screen
}

@onready var main_menu = $MainMenu
@onready var options_menu = $OptionsMenu
@onready var loading_screen = $LoadingScreen  # Ensure you have a LoadingScreen node
@onready var confirm_quit_dialog = $ConfirmQuitDialog  # Add reference to the ConfirmQuitDialog

# Variables for AudioStreamPlayers (initialized in _ready())
var audio_player_music: AudioStreamPlayer
var audio_player_effects: AudioStreamPlayer

@onready var slider_master = $OptionsMenu/CenterBoxOptions/VBoxOptions/VBoxMaster/SliderMaster
@onready var slider_music = $OptionsMenu/CenterBoxOptions/VBoxOptions/VBoxMusic/SliderMusic
@onready var slider_effects = $OptionsMenu/CenterBoxOptions/VBoxOptions/VBoxEffects/SliderEffects

@onready var button_start = $MainMenu/CenterBoxMainMenu/VBoxMainMenu/ButtonStart
@onready var button_options = $MainMenu/CenterBoxMainMenu/VBoxMainMenu/ButtonOptions
@onready var button_back = $OptionsMenu/CenterBoxOptions/VBoxOptions/ButtonBack
@onready var button_exit = $MainMenu/CenterBoxMainMenu/VBoxMainMenu/ButtonExit
@onready var button_yes = $ConfirmQuitDialog/VBoxContainer/ButtonYes
@onready var button_no = $ConfirmQuitDialog/VBoxContainer/ButtonNo

# Variables to hold the origin positions of each menu
var main_menu_origin: Vector2
var options_menu_origin: Vector2
var loading_screen_origin: Vector2  # Added for the game screen

# Target position that the current menu should move towards
var target_position: Vector2 = Vector2.ZERO

# Current menu state
var current_menu_state: MenuState = MenuState.MAIN_MENU

# Speed of the transition
var transition_speed: float = 600.0 # Adjust speed to your liking

func _ready() -> void:
	# Find the AudioStreamPlayer nodes dynamically
	audio_player_music = main_menu.get_node("CenterBoxMainMenu/VBoxMainMenu/AudioStreamPlayer") as AudioStreamPlayer
	#audio_player_effects = get_node("Character/AudioStreamPlayer2D") as AudioStreamPlayer

	update_menu_positions()

	# Check and connect buttons to their respective functions
	if not button_start.is_connected("pressed", Callable(self, "_on_button_start_pressed")):
		button_start.connect("pressed", Callable(self, "_on_button_start_pressed"))

	if not button_options.is_connected("pressed", Callable(self, "_on_button_options_pressed")):
		button_options.connect("pressed", Callable(self, "_on_button_options_pressed"))

	if not button_back.is_connected("pressed", Callable(self, "_on_button_back_pressed")):
		button_back.connect("pressed", Callable(self, "_on_button_back_pressed"))

	if not button_exit.is_connected("pressed", Callable(self, "_on_button_exit_pressed")):
		button_exit.connect("pressed", Callable(self, "_on_button_exit_pressed"))

	if not button_yes.is_connected("pressed", Callable(self, "_on_button_yes_pressed")):
		button_yes.connect("pressed", Callable(self, "_on_button_yes_pressed"))

	if not button_no.is_connected("pressed", Callable(self, "_on_button_no_pressed")):
		button_no.connect("pressed", Callable(self, "_on_button_no_pressed"))

	# Check and connect sliders to their respective functions
	if not slider_master.is_connected("value_changed", Callable(self, "_on_SliderMaster_value_changed")):
		slider_master.connect("value_changed", Callable(self, "_on_SliderMaster_value_changed"))

	if not slider_music.is_connected("value_changed", Callable(self, "_on_SliderMusic_value_changed")):
		slider_music.connect("value_changed", Callable(self, "_on_SliderMusic_value_changed"))

	if not slider_effects.is_connected("value_changed", Callable(self, "_on_SliderEffects_value_changed")):
		slider_effects.connect("value_changed", Callable(self, "_on_SliderEffects_value_changed"))

	# Start playing the main menu music
	if audio_player_music:
		audio_player_music.play()
	else:
		print("Error: AudioStreamPlayer for music not found")

	# Enable input processing to handle the Escape key
	set_process_input(true)

# Called every frame to handle smooth transitions
func _process(delta: float) -> void:
	match current_menu_state:
		MenuState.MAIN_MENU:
			# Move the MainMenu into view and the OptionsMenu off-screen
			main_menu.position = main_menu.position.move_toward(main_menu_origin, transition_speed * delta)
			options_menu.position = options_menu.position.move_toward(options_menu_origin, transition_speed * delta)
		MenuState.OPTIONS_MENU:
			# Move the OptionsMenu into view and the MainMenu off-screen
			main_menu.position = main_menu.position.move_toward(Vector2(0, 400), transition_speed * delta) # Off-screen below
			options_menu.position = options_menu.position.move_toward(Vector2(0, 0), transition_speed * delta) # Center screen
		MenuState.GAME_SCREEN:
			# Move the camera or view to the game screen
			main_menu.position = main_menu.position.move_toward(Vector2(0, -400), transition_speed * delta) # Off-screen above
			loading_screen.position = loading_screen.position.move_toward(Vector2(0, 0), transition_speed * delta)

	# Snap to the target position if close enough
	if main_menu.position.distance_to(main_menu_origin) < 1.0:
		main_menu.position = main_menu_origin
	if options_menu.position.distance_to(options_menu_origin) < 1.0:
		options_menu.position = options_menu_origin

# Update the origin positions based on the current screen size
func update_menu_positions() -> void:
	var screen_size = get_viewport_rect().size
	var menu_height = screen_size.y

	main_menu_origin = Vector2(0, 0)
	options_menu_origin = Vector2(0, -menu_height) # Positioned above the main menu
	loading_screen_origin = Vector2(0, menu_height)  # Positioned below the main menu

	if current_menu_state == MenuState.MAIN_MENU:
		main_menu.position = main_menu_origin
		target_position = main_menu_origin
	elif current_menu_state == MenuState.OPTIONS_MENU:
		options_menu.position = options_menu_origin
		target_position = options_menu_origin
	elif current_menu_state == MenuState.GAME_SCREEN:
		target_position = loading_screen_origin

# Function to transition to the Options Menu
func go_to_options_menu() -> void:
	current_menu_state = MenuState.OPTIONS_MENU
	target_position = Vector2(0, 0) # Bring OptionsMenu to the center

# Function to transition back to the Main Menu
func go_to_main_menu() -> void:
	current_menu_state = MenuState.MAIN_MENU
	target_position = Vector2(0, 0) # Bring MainMenu back to the center

# Function to transition to the Game Screen
func go_to_game_screen() -> void:
	current_menu_state = MenuState.GAME_SCREEN
	target_position = loading_screen_origin  # Bring LoadingScreen into view

	# Wait for the loading screen transition
	await get_tree().create_timer(2.0).timeout  # Wait for 1 second (adjust as needed)

	# Load and change to the game scene
	var error = get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")
	if error != OK:
		print("Failed to change scene: ", error)

# Function to show confirm quit dialog
func show_confirm_quit_dialog() -> void:
	confirm_quit_dialog.popup_centered()

# Button functions
func _on_button_start_pressed() -> void:
	go_to_game_screen()

func _on_button_options_pressed() -> void:
	go_to_options_menu()

func _on_button_back_pressed() -> void:
	go_to_main_menu()

func _on_button_exit_pressed() -> void:
	get_tree().quit()

func _on_button_yes_pressed() -> void:
	get_tree().quit()

func _on_button_no_pressed() -> void:
	confirm_quit_dialog.hide()

# Slider value change handlers
func _on_SliderMaster_value_changed(value: float) -> void:
	# Map the slider value to a dB range from -80 dB (silent) to 0 dB (max volume)
	var db_value = linear_to_db(value / 80.0)
	AudioServer.set_bus_volume_db(0, db_value)

func _on_SliderMusic_value_changed(value: float) -> void:
	if audio_player_music:
		var db_value = linear_to_db(value / 100.0)
		audio_player_music.volume_db = db_value

func _on_SliderEffects_value_changed(value: float) -> void:
	if audio_player_effects:
		var db_value = linear_to_db(value / 100.0)
		audio_player_effects.volume_db = db_value

# Utility function to convert a linear value (0.0 to 1.0) to dB
func linear_to_db(value: float) -> float:
	# Convert from linear (0.0 to 1.0) to decibels (-80 dB to 0 dB)
	return lerp(-80.0, 0.0, value)

# Handle input for the Escape key to show confirm quit dialog
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		show_confirm_quit_dialog()
