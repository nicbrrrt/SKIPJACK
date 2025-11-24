function scr_get_random_map() {
    var maps = [];
    
    // Map 1: Simple corridor
    maps[0] = [
        [1,1,1,1,1,1,1,1],
        [1,0,0,0,0,0,0,1],
        [1,0,1,1,0,1,0,1],
        [1,0,1,0,0,1,0,1],
        [1,0,0,0,1,1,0,1],
        [1,1,1,1,1,1,1,1]
    ];
    
    // Map 2: Maze-like
    maps[1] = [
        [1,1,1,1,1,1,1,1],
        [1,0,0,0,1,0,0,1],
        [1,1,1,0,1,0,1,1],
        [1,0,0,0,0,0,0,1],
        [1,0,1,1,1,1,0,1],
        [1,1,1,1,1,1,1,1]
    ];
    
    // Map 3: Open with islands
    maps[2] = [
        [1,1,1,1,1,1,1,1],
        [1,0,0,0,0,0,0,1],
        [1,0,1,0,1,0,1,1],
        [1,0,0,0,1,0,0,1],
        [1,1,0,1,1,0,0,1],
        [1,1,1,1,1,1,1,1]
    ];
    
    // Map 4: Spiral
    maps[3] = [
        [1,1,1,1,1,1,1,1],
        [1,0,0,0,0,0,0,1],
        [1,0,1,1,1,1,0,1],
        [1,0,1,0,0,1,0,1],
        [1,0,0,0,0,0,0,1],
        [1,1,1,1,1,1,1,1]
    ];
    
    // Map 5: Cross pattern
    maps[4] = [
        [1,1,1,1,1,1,1,1],
        [1,0,1,0,0,1,0,1],
        [1,0,1,0,0,1,0,1],
        [1,0,0,0,0,0,0,1],
        [1,0,1,0,0,1,0,1],
        [1,1,1,1,1,1,1,1]
    ];
    
    // Return a random map
    return maps[irandom(array_length(maps) - 1)];
}

function scr_get_random_start_target() {
    var positions = [];
    
    // Different start/target position combinations
    positions[0] = { start: [1, 1], target: [6, 4] };      // Top-left to Bottom-right
    positions[1] = { start: [1, 4], target: [6, 4] };      // Bottom-left to Top-right  
    positions[2] = { start: [1, 1], target: [6, 4] };      // Left-middle to Right-middle
    positions[3] = { start: [1, 4], target: [6, 1] };      // Diagonal positions
    
    return positions[irandom(array_length(positions) - 1)];
}