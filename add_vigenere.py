import json
import os
import uuid

# Base path
base_path = r"C:\Users\sewel\GameMakerProjects\SKIPJACK"

def create_gml(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def create_yy(path, resource_type, name, parent_name, parent_path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    
    data = {
        "resourceType": resource_type,
        "resourceVersion": "2.0",
        "name": name,
        "$GMScript": "v1" if resource_type == "GMScript" else undefined,
        "$GMObject": "v1" if resource_type == "GMObject" else undefined,
        "isCompatibility": False if resource_type == "GMScript" else undefined,
        "isDnD": False if resource_type == "GMScript" else undefined,
        "parent": {
            "name": parent_name,
            "path": parent_path
        }
    }
    
    if resource_type == "GMObject":
        data.update({
            "spriteId": None,
            "solid": False,
            "visible": True,
            "managed": True,
            "spriteMaskId": None,
            "persistent": False,
            "parentObjectId": None,
            "physicsObject": False,
            "physicsSensor": False,
            "physicsShape": 1,
            "physicsGroup": 1,
            "physicsDensity": 0.5,
            "physicsRestitution": 0.1,
            "physicsLinearDamping": 0.1,
            "physicsAngularDamping": 0.1,
            "physicsFriction": 0.2,
            "physicsStartAwake": True,
            "physicsKinematic": False,
            "physicsShapePoints": [],
            "eventList": [],
            "properties": [],
            "overriddenProperties": []
        })
        
        # Add par_npc as parent for NPCs
        if name.startswith("obj_npc_"):
            data["parentObjectId"] = {
                "name": "par_npc",
                "path": "objects/par_npc/par_npc.yy"
            }
            
    # Clean up undefined keys
    data = {k: v for k, v in data.items() if v != 'undefined' and v is not type(NotImplemented)}
    if "$GMScript" not in data and resource_type == "GMScript": data["$GMScript"] = "v1"
    if "$GMObject" not in data and resource_type == "GMObject": data["$GMObject"] = "v1"
    
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

def add_event_to_yy(path, event_type, event_num):
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    data["eventList"].append({
        "$GMEvent": "v1",
        "%Name": "",
        "isDnD": False,
        "eventNum": event_num,
        "eventType": event_type,
        "collisionObjectId": None,
        "resourceType": "GMEvent",
        "resourceVersion": "2.0"
    })
    
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)


def add_to_yyp(name, path):
    yyp_path = os.path.join(base_path, "SKIPJACK.yyp")
    with open(yyp_path, "r", encoding="utf-8") as f:
        yyp_data = json.load(f)
        
    for res in yyp_data["resources"]:
        if res["id"]["name"] == name:
            return # already exists
            
    yyp_data["resources"].append({
        "id": {
            "name": name,
            "path": path
        }
    })
    
    with open(yyp_path, "w", encoding="utf-8") as f:
        json.dump(yyp_data, f, indent=2)


# 1. Scripts
scripts = [
    ("scr_vigenere_encode", "function scr_vigenere_encode(text, key) {\n    var res = \"\";\n    key = string_upper(key);\n    var key_len = string_length(key);\n    var key_idx = 0;\n    for (var i = 1; i <= string_length(text); i++) {\n        var c = string_char_at(text, i);\n        if (c == \" \") {\n            res += \" \";\n            continue;\n        }\n        var char_idx = ord(c) - ord(\"A\");\n        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord(\"A\");\n        var s = (char_idx + shift) mod 26;\n        res += chr(s + ord(\"A\"));\n        key_idx++;\n    }\n    return res;\n}"),
    ("scr_vigenere_decode", "function scr_vigenere_decode(text, key) {\n    var res = \"\";\n    key = string_upper(key);\n    var key_len = string_length(key);\n    var key_idx = 0;\n    for (var i = 1; i <= string_length(text); i++) {\n        var c = string_char_at(text, i);\n        if (c == \" \") {\n            res += \" \";\n            continue;\n        }\n        var char_idx = ord(c) - ord(\"A\");\n        var shift = ord(string_char_at(key, (key_idx mod key_len) + 1)) - ord(\"A\");\n        var s = (char_idx - shift) mod 26;\n        if (s < 0) s += 26;\n        res += chr(s + ord(\"A\"));\n        key_idx++;\n    }\n    return res;\n}")
]

for name, content in scripts:
    s_path = os.path.join(base_path, "scripts", name)
    create_gml(os.path.join(s_path, f"{name}.gml"), content)
    create_yy(os.path.join(s_path, f"{name}.yy"), "GMScript", name, "Scripts", "folders/Scripts.yy")
    add_to_yyp(name, f"scripts/{name}/{name}.yy")


# 2. Objects
objects = [
    ("obj_vigenere_theory_gui", "Objects", "folders/Objects.yy"),
    ("obj_vigenere_board_gui", "Objects", "folders/Objects.yy"),
    ("obj_vigenere_test_gui", "Objects", "folders/Objects.yy"),
    ("obj_npc_vigenere_theory", "Objects", "folders/Objects.yy"),
    ("obj_npc_vigenere_minigame", "Objects", "folders/Objects.yy"),
    ("obj_npc_vigenere_test", "Objects", "folders/Objects.yy")
]

for name, p_name, p_path in objects:
    o_path = os.path.join(base_path, "objects", name)
    create_yy(os.path.join(o_path, f"{name}.yy"), "GMObject", name, p_name, p_path)
    add_to_yyp(name, f"objects/{name}/{name}.yy")

print("Files created and YYP updated successfully.")
