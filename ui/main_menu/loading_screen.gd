extends Node2D  # or the appropriate node type

# Called when the node enters the scene tree for the first time.
func _ready():
	# Access the material of the node (assuming it's a ShaderMaterial)
	var shader_material = $LoadingScreen.material  # Replace "YourNode" with the correct path to your node

	# Set the glow_colors uniform in the shader
	shader_material.set_shader_param("glow_colors", [
		Vector4(0.972, 0.451, 0.125, 1.0),  # Color 1: #F87320
		Vector4(0.510, 0.392, 0.745, 1.0),  # Color 2: #8264BE
		Vector4(0.400, 0.220, 0.761, 1.0),  # Color 3: #6638C2
		Vector4(0.086, 0.557, 0.710, 1.0)   # Color 4: #168EB5
	])
