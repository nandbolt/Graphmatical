// States
interactable = true;
playerNear = false;

// Info
name = "";
showName = true;

#region Functions

/// @func	interact();
interact = function(){}

/// @func	interactPressed();
interactPressed = function(){}

/// @func	onPlayerNear();
onPlayerNear = function(){}

#endregion

#region Outline Shader

// Color
colorOutline = [1.0, 1.0, 1.0];

// Texture
texSprite = sprite_get_texture(sprite_index, 0);
texelWidth = texture_get_texel_width(texSprite);
texelHeight = texture_get_texel_height(texSprite);

// Get uniforms
uColorOutline = shader_get_uniform(shdrOutline, "u_colorOutline");
uTexelWidth = shader_get_uniform(shdrOutline, "u_texelWidth");
uTexelHeight = shader_get_uniform(shdrOutline, "u_texelHeight");

#endregion