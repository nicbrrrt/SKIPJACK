// --- ALARM 0 (QTE SPAWN) ---

show_debug_message("BATTLE: Spawning QTE...");

if (global.seen_qte_tutorial == false) {
    var tut = instance_create_layer(0, 0, "Instances", obj_tutorial);
    tut.text_title = "INCOMING PACKET";
    tut.text_body = "A Corrupted Packet is flying at you!\n\nPress the arrow keys shown above the packet to catch it before it hits you!";
    tut.next_object = obj_qte;
    
    global.seen_qte_tutorial = true;
} else {
    instance_create_layer(0, 0, "Instances", obj_qte);
}