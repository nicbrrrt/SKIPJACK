$basePath = "C:\Users\sewel\GameMakerProjects\SKIPJACK"

function Create-Gml($path, $content) {
    $dir = Split-Path $path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    Set-Content -Path $path -Value $content -Encoding UTF8
}

function Create-Yy($path, $resourceType, $name, $parentName, $parentPath) {
    $dir = Split-Path $path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    
    $data = @{
        resourceType = $resourceType
        resourceVersion = "2.0"
        name = $name
        parent = @{
            name = $parentName
            path = $parentPath
        }
    }
    
    if ($resourceType -eq "GMScript") {
        $data["`$GMScript"] = "v1"
        $data["isCompatibility"] = $false
        $data["isDnD"] = $false
    }
    
    if ($resourceType -eq "GMObject") {
        $data["`$GMObject"] = "v1"
        $data["spriteId"] = $null
        $data["solid"] = $false
        $data["visible"] = $true
        $data["managed"] = $true
        $data["spriteMaskId"] = $null
        $data["persistent"] = $false
        $data["parentObjectId"] = $null
        $data["physicsObject"] = $false
        $data["physicsSensor"] = $false
        $data["physicsShape"] = 1
        $data["physicsGroup"] = 1
        $data["physicsDensity"] = 0.5
        $data["physicsRestitution"] = 0.1
        $data["physicsLinearDamping"] = 0.1
        $data["physicsAngularDamping"] = 0.1
        $data["physicsFriction"] = 0.2
        $data["physicsStartAwake"] = $true
        $data["physicsKinematic"] = $false
        $data["physicsShapePoints"] = @()
        $data["eventList"] = @()
        $data["properties"] = @()
        $data["overriddenProperties"] = @()
        
        if ($name.StartsWith("obj_npc_")) {
            $data["parentObjectId"] = @{
                name = "par_npc"
                path = "objects/par_npc/par_npc.yy"
            }
        }
    }
    
    $json = $data | ConvertTo-Json -Depth 10
    Set-Content -Path $path -Value $json -Encoding UTF8
}

function Add-To-Yyp($name, $path) {
    $yypPath = Join-Path $basePath "SKIPJACK.yyp"
    $yyp = Get-Content -Path $yypPath -Raw | ConvertFrom-Json
    
    $exists = $false
    foreach ($res in $yyp.resources) {
        if ($res.id.name -eq $name) {
            $exists = $true
            break
        }
    }
    
    if (-not $exists) {
        $newRes = @{
            id = @{
                name = $name
                path = $path
            }
        }
        $yyp.resources += $newRes
        $json = $yyp | ConvertTo-Json -Depth 10
        Set-Content -Path $yypPath -Value $json -Encoding UTF8
    }
}

$scripts = @(
    @{ name = "scr_vigenere_encode"; content = "function scr_vigenere_encode(text, key) {`n    var res = `"`";`n    key = string_upper(key);`n    var key_len = string_length(key);`n    var key_idx = 0;`n    for (var i = 1; i <= string_length(text); i++) {`n        var c = string_char_at(text, i);`n        if (c == `" `") {`n            res += `" `";`n            continue;`n        }`n        var char_idx = ord(c) - ord(`"A`");`n        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord(`"A`");`n        var s = (char_idx + shift) mod 26;`n        res += chr(s + ord(`"A`"));`n        key_idx++;`n    }`n    return res;`n}" },
    @{ name = "scr_vigenere_decode"; content = "function scr_vigenere_decode(text, key) {`n    var res = `"`";`n    key = string_upper(key);`n    var key_len = string_length(key);`n    var key_idx = 0;`n    for (var i = 1; i <= string_length(text); i++) {`n        var c = string_char_at(text, i);`n        if (c == `" `") {`n            res += `" `";`n            continue;`n        }`n        var char_idx = ord(c) - ord(`"A`");`n        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord(`"A`");`n        var s = (char_idx - shift) mod 26;`n        if (s < 0) s += 26;`n        res += chr(s + ord(`"A`"));`n        key_idx++;`n    }`n    return res;`n}" }
)

foreach ($s in $scripts) {
    $sPath = Join-Path $basePath "scripts\$($s.name)"
    Create-Gml (Join-Path $sPath "$($s.name).gml") $s.content
    Create-Yy (Join-Path $sPath "$($s.name).yy") "GMScript" $s.name "Scripts" "folders/Scripts.yy"
    Add-To-Yyp $s.name "scripts/$($s.name)/$($s.name).yy"
}

$objects = @(
    @{ name = "obj_vigenere_theory_gui"; pName = "Objects"; pPath = "folders/Objects.yy" },
    @{ name = "obj_vigenere_board_gui"; pName = "Objects"; pPath = "folders/Objects.yy" },
    @{ name = "obj_vigenere_test_gui"; pName = "Objects"; pPath = "folders/Objects.yy" },
    @{ name = "obj_npc_vigenere_theory"; pName = "Objects"; pPath = "folders/Objects.yy" },
    @{ name = "obj_npc_vigenere_minigame"; pName = "Objects"; pPath = "folders/Objects.yy" },
    @{ name = "obj_npc_vigenere_test"; pName = "Objects"; pPath = "folders/Objects.yy" }
)

foreach ($o in $objects) {
    $oPath = Join-Path $basePath "objects\$($o.name)"
    Create-Yy (Join-Path $oPath "$($o.name).yy") "GMObject" $o.name $o.pName $o.pPath
    Add-To-Yyp $o.name "objects/$($o.name)/$($o.name).yy"
}

Write-Output "PowerShell script completed successfully."
