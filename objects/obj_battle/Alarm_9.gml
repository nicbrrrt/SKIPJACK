/// Alarm 9 - Battle Conclusion
if (room_exists(global.return_room)) {
    room_goto(global.return_room);
} else {
    room_goto(rm_hallway); 
}