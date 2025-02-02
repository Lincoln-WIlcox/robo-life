extends Node2D

const GRID_SIZE = 2

const FOG_COLOR = Color.BLACK

@export var scrollable_container: Node2D
@export var light_texture: Texture2D
@export var fog_sprite: Sprite2D


var fog_image: Image = Image.new()
var fog_texture: ImageTexture = ImageTexture.new()

@onready var light_offset = Vector2(light_texture.get_width() / 2, light_texture.get_height() / 2)
@onready var light_image: Image = light_texture.get_image()

func _ready():
	light_image.convert(Image.FORMAT_RGBAH)
	
	fog_sprite.scale = Vector2.ONE * GRID_SIZE
	
	create_fog_image(get_viewport_rect().size)

func create_fog_image(size: Vector2) -> void:
	var fog_image_width = size.x/GRID_SIZE
	var fog_image_height = size.y/GRID_SIZE
	
	fog_image = Image.create_empty(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fog_image.fill(FOG_COLOR)
	
	_update_fog_image_texture()

func update_fog(new_grid_position: Vector2) -> void:
	var light_rect: Rect2 = Rect2(Vector2.ZERO, Vector2(light_image.get_width(), light_image.get_height()))
	fog_image.blend_rect(light_image, light_rect, new_grid_position - light_offset)
	_update_fog_image_texture()

func _update_fog_image_texture() -> void:
	fog_texture = ImageTexture.create_from_image(fog_image)
	fog_sprite.texture = fog_texture

func _input(event):
	update_fog(fog_sprite.to_local(get_local_mouse_position()))
