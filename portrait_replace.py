"""
portrait_replace.py
Replaces character portrait sprites in the Skipjack GMS2 project with new images.
Requires: pip install Pillow
"""

import os
import uuid
from PIL import Image

# ── Paths ─────────────────────────────────────────────────────────────────────
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
SOURCE_DIR = r"F:\xtra downloads folder\Capstone 2\Generated Media"
SPRITES_DIR = os.path.join(PROJECT_DIR, "sprites")
YYP_PATH = os.path.join(PROJECT_DIR, "SKIPJACK.yyp")

# ── Source image mapping ───────────────────────────────────────────────────────
# (sprite_name, source_filename, is_new_sprite)
PORTRAITS = [
    ("spr_jack_portrait",    "Jack Pine.png",       False),  # replace in-place
    ("spr_greg_portrait",    "Greg Cropped.png",    True),
    ("spr_breado_portrait",  "Breado Cropped.png",  True),
    ("spr_clipper_portrait", "Clipper Chip.png",    True),
    ("spr_lea_portrait",     "Lea.png",             True),
]

# Jack's existing UUIDs (must stay the same so .yy file keeps referencing them)
JACK_FRAME_UUID = "952a404d-6dfb-47e5-bc7d-2f85f92778c5"
JACK_LAYER_UUID = "cfd03233-77d0-42da-b067-5a438a676798"

SIZE = (64, 64)


def center_crop_64(src_path):
    """Open an image and return a 64x64 center-cropped version."""
    img = Image.open(src_path).convert("RGBA")
    w, h = img.size
    # Scale so shorter side = 64
    scale = SIZE[0] / min(w, h)
    new_w = round(w * scale)
    new_h = round(h * scale)
    img = img.resize((new_w, new_h), Image.LANCZOS)
    # Center crop
    left = (new_w - SIZE[0]) // 2
    top  = (new_h - SIZE[1]) // 2
    return img.crop((left, top, left + SIZE[0], top + SIZE[1]))


def make_yy(sprite_name, frame_uuid, layer_uuid, keyframe_uuid):
    """Build the GMS2 .yy JSON string for a single-frame 64x64 portrait sprite."""
    template = (
        '{\n'
        '  "$GMSprite":"v2",\n'
        '  "%Name":"SPRITE_NAME",\n'
        '  "bboxMode":0,\n'
        '  "bbox_bottom":63,\n'
        '  "bbox_left":0,\n'
        '  "bbox_right":63,\n'
        '  "bbox_top":0,\n'
        '  "collisionKind":1,\n'
        '  "collisionTolerance":0,\n'
        '  "DynamicTexturePage":false,\n'
        '  "edgeFiltering":false,\n'
        '  "For3D":false,\n'
        '  "frames":[\n'
        '    {"$GMSpriteFrame":"v1","%Name":"FRAME_UUID","name":"FRAME_UUID","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},\n'
        '  ],\n'
        '  "gridX":0,\n'
        '  "gridY":0,\n'
        '  "height":64,\n'
        '  "HTile":false,\n'
        '  "layers":[\n'
        '    {"$GMImageLayer":"","%Name":"LAYER_UUID","blendMode":0,"displayName":"default","isLocked":false,"name":"LAYER_UUID","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},\n'
        '  ],\n'
        '  "name":"SPRITE_NAME",\n'
        '  "nineSlice":null,\n'
        '  "origin":0,\n'
        '  "parent":{\n'
        '    "name":"Character Sprite",\n'
        '    "path":"folders/Sprites/Character Sprite.yy",\n'
        '  },\n'
        '  "preMultiplyAlpha":false,\n'
        '  "resourceType":"GMSprite",\n'
        '  "resourceVersion":"2.0",\n'
        '  "sequence":{\n'
        '    "$GMSequence":"v1",\n'
        '    "%Name":"SPRITE_NAME",\n'
        '    "autoRecord":true,\n'
        '    "backdropHeight":768,\n'
        '    "backdropImageOpacity":0.5,\n'
        '    "backdropImagePath":"",\n'
        '    "backdropWidth":1366,\n'
        '    "backdropXOffset":0.0,\n'
        '    "backdropYOffset":0.0,\n'
        '    "events":{\n'
        '      "$KeyframeStore<MessageEventKeyframe>":"",\n'
        '      "Keyframes":[],\n'
        '      "resourceType":"KeyframeStore<MessageEventKeyframe>",\n'
        '      "resourceVersion":"2.0",\n'
        '    },\n'
        '    "eventStubScript":null,\n'
        '    "eventToFunction":{},\n'
        '    "length":1.0,\n'
        '    "lockOrigin":false,\n'
        '    "moments":{\n'
        '      "$KeyframeStore<MomentsEventKeyframe>":"",\n'
        '      "Keyframes":[],\n'
        '      "resourceType":"KeyframeStore<MomentsEventKeyframe>",\n'
        '      "resourceVersion":"2.0",\n'
        '    },\n'
        '    "name":"SPRITE_NAME",\n'
        '    "playback":1,\n'
        '    "playbackSpeed":30.0,\n'
        '    "playbackSpeedType":0,\n'
        '    "resourceType":"GMSequence",\n'
        '    "resourceVersion":"2.0",\n'
        '    "showBackdrop":true,\n'
        '    "showBackdropImage":false,\n'
        '    "timeUnits":1,\n'
        '    "tracks":[\n'
        '      {"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[\n'
        '            {"$Keyframe<SpriteFrameKeyframe>":"","Channels":{\n'
        '                "0":{"$SpriteFrameKeyframe":"","Id":{"name":"FRAME_UUID","path":"sprites/SPRITE_NAME/SPRITE_NAME.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},\n'
        '              },"Disabled":false,"id":"KEYFRAME_UUID","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},\n'
        '          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},\n'
        '    ],\n'
        '    "visibleRange":null,\n'
        '    "volume":1.0,\n'
        '    "xorigin":0,\n'
        '    "yorigin":0,\n'
        '  },\n'
        '  "swatchColours":null,\n'
        '  "swfPrecision":0.5,\n'
        '  "textureGroupId":{\n'
        '    "name":"Default",\n'
        '    "path":"texturegroups/Default",\n'
        '  },\n'
        '  "type":0,\n'
        '  "VTile":false,\n'
        '  "width":64,\n'
        '}'
    )
    return (template
            .replace("SPRITE_NAME", sprite_name)
            .replace("FRAME_UUID", frame_uuid)
            .replace("LAYER_UUID", layer_uuid)
            .replace("KEYFRAME_UUID", keyframe_uuid))


def replace_jack(img):
    """Overwrite Jack's existing portrait PNGs in-place."""
    sprite_dir = os.path.join(SPRITES_DIR, "spr_jack_portrait")
    frame_path = os.path.join(sprite_dir, JACK_FRAME_UUID + ".png")
    layer_path = os.path.join(sprite_dir, "layers", JACK_FRAME_UUID, JACK_LAYER_UUID + ".png")
    img.save(frame_path, "PNG")
    img.save(layer_path, "PNG")
    print("  OK  Replaced spr_jack_portrait PNGs")


def create_sprite(sprite_name, img):
    """Create a brand-new GMS2 sprite directory for a character."""
    frame_uuid    = str(uuid.uuid4())
    layer_uuid    = str(uuid.uuid4())
    keyframe_uuid = str(uuid.uuid4())

    sprite_dir = os.path.join(SPRITES_DIR, sprite_name)
    layer_dir  = os.path.join(sprite_dir, "layers", frame_uuid)
    os.makedirs(sprite_dir, exist_ok=True)
    os.makedirs(layer_dir,  exist_ok=True)

    img.save(os.path.join(sprite_dir, frame_uuid + ".png"), "PNG")
    img.save(os.path.join(layer_dir,  layer_uuid + ".png"), "PNG")

    yy_content = make_yy(sprite_name, frame_uuid, layer_uuid, keyframe_uuid)
    with open(os.path.join(sprite_dir, sprite_name + ".yy"), "w", encoding="utf-8") as f:
        f.write(yy_content)

    print("  OK  Created " + sprite_name + "/")


def update_yyp(new_sprite_names):
    """Insert new sprite resource entries into SKIPJACK.yyp (alphabetically)."""
    with open(YYP_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    for sprite_name in new_sprite_names:
        if ('"name":"' + sprite_name + '"') in content:
            print("  --  " + sprite_name + " already in .yyp, skipping")
            continue

        entry = ('    {"id":{"name":"' + sprite_name + '","path":"sprites/' +
                 sprite_name + '/' + sprite_name + '.yy",},},')

        # Find the insertion point: first sprite entry that sorts after this name
        lines = content.split("\n")
        insert_idx = None
        for i, line in enumerate(lines):
            if '"path":"sprites/spr_' in line:
                # Extract the sprite name from the line
                name_marker = '"name":"'
                start = line.find(name_marker)
                if start == -1:
                    continue
                start += len(name_marker)
                end = line.find('"', start)
                existing_name = line[start:end]
                if existing_name > sprite_name:
                    insert_idx = i
                    break

        if insert_idx is not None:
            lines.insert(insert_idx, entry)
            content = "\n".join(lines)
            print("  OK  Added " + sprite_name + " to .yyp")
        else:
            print("  !!  Could not find insertion point for " + sprite_name)

    with open(YYP_PATH, "w", encoding="utf-8") as f:
        f.write(content)


def main():
    print("=== Skipjack Portrait Replacer ===\n")

    new_sprites = []

    for sprite_name, source_file, is_new in PORTRAITS:
        src_path = os.path.join(SOURCE_DIR, source_file)
        if not os.path.exists(src_path):
            print("MISSING source: " + src_path)
            continue

        print("Processing " + sprite_name + " <- " + source_file)
        img = center_crop_64(src_path)

        if is_new:
            create_sprite(sprite_name, img)
            new_sprites.append(sprite_name)
        else:
            replace_jack(img)

    print("\nUpdating SKIPJACK.yyp...")
    if new_sprites:
        update_yyp(new_sprites)

    print("\nAll done!")


if __name__ == "__main__":
    main()
