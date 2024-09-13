extends Node

var settings_data : SettingsDataResource

var save_path : String = "user://game_data/"
var save_file : String = "settings_data.tres"

func load_settings():
	if !DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_absolute(save_path)

	if ResourceLoader.exists(save_path + save_file):
		settings_data = load(save_path + save_file)
	else:
		settings_data = SettingsDataResource.new()
		save_settings() 
	if settings_data == null:
		settings_data = SettingsDataResource.new()
	if settings_data != null:
		set_window_mode(settings_data.window_mode, settings_data.window_mode_index)
		set_resolution(settings_data.resolution, settings_data.resolution_index)
		set_master_volume(settings_data.master_volume)
		set_music_volume(settings_data.music_volume)
		set_effects_volume(settings_data.effects_volume)

func set_window_mode(window_mode : int, window_mode_index : int):
	match window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	settings_data.window_mode = window_mode
	settings_data.window_mode_index = window_mode_index


func set_resolution(resolution : Vector2i, resolution_index : int):
	get_tree().root.content_scale_size = resolution
	settings_data.resolution = resolution
	settings_data.resolution_index = resolution_index

func set_master_volume(master_volume : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
	settings_data.master_volume = master_volume

func set_music_volume(music_volume : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	settings_data.music_volume = music_volume

func set_effects_volume(effects_volume : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), effects_volume)
	settings_data.effects_volume = effects_volume

func get_settings_data():
	return settings_data

func save_settings() -> SettingsDataResource:
	ResourceSaver.save(settings_data, save_path + save_file)
	return settings_data
