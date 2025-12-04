if (vspeed > 0) image_alpha -= 0.05; // Fade out
if (image_alpha <= 0) instance_destroy();