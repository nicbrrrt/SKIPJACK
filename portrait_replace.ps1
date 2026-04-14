# portrait_replace.ps1
# Replaces character portrait sprites in the Skipjack GMS2 project with new images.
# Uses System.Drawing (built into Windows PowerShell) for image resizing.

Add-Type -AssemblyName System.Drawing

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir  = "F:\xtra downloads folder\Capstone 2\Generated Media"
$SpritesDir = Join-Path $ProjectDir "sprites"
$YypPath    = Join-Path $ProjectDir "SKIPJACK.yyp"

# Jack's existing UUIDs (must stay the same)
$JackFrameUUID = "952a404d-6dfb-47e5-bc7d-2f85f92778c5"
$JackLayerUUID = "cfd03233-77d0-42da-b067-5a438a676798"

# Character -> source file mapping
$Portraits = @(
    @{ Name = "spr_jack_portrait";    Source = "Jack Pine.png";      IsNew = $false },
    @{ Name = "spr_greg_portrait";    Source = "Greg Cropped.png";   IsNew = $true  },
    @{ Name = "spr_breado_portrait";  Source = "Breado Cropped.png"; IsNew = $true  },
    @{ Name = "spr_clipper_portrait"; Source = "Clipper Chip.png";   IsNew = $true  },
    @{ Name = "spr_lea_portrait";     Source = "Lea.png";            IsNew = $true  }
)

function Center-Crop64 {
    param([string]$SrcPath)
    $original = [System.Drawing.Image]::FromFile($SrcPath)
    $w = $original.Width
    $h = $original.Height
    # Scale so shorter side = 64
    if ($w -le $h) { $scale = 64.0 / $w } else { $scale = 64.0 / $h }
    $newW = [int][Math]::Round($w * $scale)
    $newH = [int][Math]::Round($h * $scale)
    # Scale
    $scaled = New-Object System.Drawing.Bitmap($newW, $newH)
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($original, 0, 0, $newW, $newH)
    $g.Dispose()
    $original.Dispose()
    # Center crop to 64x64
    $left = [int](($newW - 64) / 2)
    $top  = [int](($newH - 64) / 2)
    $cropped = New-Object System.Drawing.Bitmap(64, 64)
    $gc = [System.Drawing.Graphics]::FromImage($cropped)
    $gc.DrawImage($scaled, 0, 0, (New-Object System.Drawing.Rectangle($left, $top, 64, 64)), [System.Drawing.GraphicsUnit]::Pixel)
    $gc.Dispose()
    $scaled.Dispose()
    return $cropped
}

function Save-Png {
    param([System.Drawing.Bitmap]$Img, [string]$OutPath)
    $dir = Split-Path -Parent $OutPath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $Img.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
}

function Make-YY {
    param([string]$SpriteName, [string]$FrameUUID, [string]$LayerUUID, [string]$KeyframeUUID)
    return @"
{
  "`$GMSprite":"v2",
  "%Name":"$SpriteName",
  "bboxMode":0,
  "bbox_bottom":63,
  "bbox_left":0,
  "bbox_right":63,
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
    {"`$GMSpriteFrame":"v1","%Name":"$FrameUUID","name":"$FrameUUID","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
  ],
  "gridX":0,
  "gridY":0,
  "height":64,
  "HTile":false,
  "layers":[
    {"`$GMImageLayer":"","%Name":"$LayerUUID","blendMode":0,"displayName":"default","isLocked":false,"name":"$LayerUUID","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"$SpriteName",
  "nineSlice":null,
  "origin":0,
  "parent":{
    "name":"Character Sprite",
    "path":"folders/Sprites/Character Sprite.yy",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "`$GMSequence":"v1",
    "%Name":"$SpriteName",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{
      "`$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "eventStubScript":null,
    "eventToFunction":{},
    "length":1.0,
    "lockOrigin":false,
    "moments":{
      "`$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"$SpriteName",
    "playback":1,
    "playbackSpeed":30.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"`$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"`$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
            {"`$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                "0":{"`$SpriteFrameKeyframe":"","Id":{"name":"$FrameUUID","path":"sprites/$SpriteName/$SpriteName.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
              },"Disabled":false,"id":"$KeyframeUUID","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":0,
    "yorigin":0,
  },
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{
    "name":"Default",
    "path":"texturegroups/Default",
  },
  "type":0,
  "VTile":false,
  "width":64,
}
"@
}

function Replace-Jack {
    param([System.Drawing.Bitmap]$Img)
    $framePath = Join-Path $SpritesDir "spr_jack_portrait\$JackFrameUUID.png"
    $layerPath = Join-Path $SpritesDir "spr_jack_portrait\layers\$JackFrameUUID\$JackLayerUUID.png"
    Save-Png -Img $Img -OutPath $framePath
    Save-Png -Img $Img -OutPath $layerPath
    Write-Host "  OK  Replaced spr_jack_portrait PNGs"
}

function Create-Sprite {
    param([string]$SpriteName, [System.Drawing.Bitmap]$Img)
    $frameUUID    = [System.Guid]::NewGuid().ToString()
    $layerUUID    = [System.Guid]::NewGuid().ToString()
    $keyframeUUID = [System.Guid]::NewGuid().ToString()

    $spriteDir = Join-Path $SpritesDir $SpriteName
    $layerDir  = Join-Path $spriteDir "layers\$frameUUID"
    New-Item -ItemType Directory -Path $spriteDir -Force | Out-Null
    New-Item -ItemType Directory -Path $layerDir  -Force | Out-Null

    Save-Png -Img $Img -OutPath (Join-Path $spriteDir "$frameUUID.png")
    Save-Png -Img $Img -OutPath (Join-Path $layerDir  "$layerUUID.png")

    $yyContent = Make-YY -SpriteName $SpriteName -FrameUUID $frameUUID -LayerUUID $layerUUID -KeyframeUUID $keyframeUUID
    [System.IO.File]::WriteAllText((Join-Path $spriteDir "$SpriteName.yy"), $yyContent, [System.Text.Encoding]::UTF8)

    Write-Host "  OK  Created $SpriteName/"
}

function Update-YYP {
    param([string[]]$NewSpriteNames)
    $content = [System.IO.File]::ReadAllText($YypPath, [System.Text.Encoding]::UTF8)

    foreach ($spriteName in $NewSpriteNames) {
        if ($content -match [regex]::Escape("`"name`":`"$spriteName`"")) {
            Write-Host "  --  $spriteName already in .yyp, skipping"
            continue
        }
        $entry = "    {`"id`":{`"name`":`"$spriteName`",`"path`":`"sprites/$spriteName/$spriteName.yy`",},},"

        # Split into lines and find the alphabetical insertion point
        $lines = $content -split "`n"
        $insertIdx = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '"path":"sprites/spr_') {
                if ($lines[$i] -match '"name":"([^"]+)"') {
                    $existingName = $Matches[1]
                    if ([string]::Compare($existingName, $spriteName, $true) -gt 0) {
                        $insertIdx = $i
                        break
                    }
                }
            }
        }

        if ($insertIdx -ge 0) {
            $linesList = [System.Collections.Generic.List[string]]$lines
            $linesList.Insert($insertIdx, $entry)
            $content = $linesList -join "`n"
            Write-Host "  OK  Added $spriteName to .yyp"
        } else {
            Write-Host "  !!  Could not find insertion point for $spriteName"
        }
    }

    [System.IO.File]::WriteAllText($YypPath, $content, [System.Text.Encoding]::UTF8)
}

# ── Main ──────────────────────────────────────────────────────────────────────
Write-Host "=== Skipjack Portrait Replacer ===`n"

$newSprites = @()

foreach ($p in $Portraits) {
    $srcPath = Join-Path $SourceDir $p.Source
    if (-not (Test-Path $srcPath)) {
        Write-Host "  MISSING: $srcPath"
        continue
    }
    Write-Host "Processing $($p.Name) <- $($p.Source)"
    $img = Center-Crop64 -SrcPath $srcPath

    if ($p.IsNew) {
        Create-Sprite -SpriteName $p.Name -Img $img
        $newSprites += $p.Name
    } else {
        Replace-Jack -Img $img
    }
    $img.Dispose()
}

Write-Host "`nUpdating SKIPJACK.yyp..."
if ($newSprites.Count -gt 0) {
    Update-YYP -NewSpriteNames $newSprites
}

Write-Host "`nAll done!"
