var area = function(radius, x, y) {
    fill(0);
    var a = PI * (radius * radius);
    text(a, x, y);
};

var x = 10, y = 0, col = 0, lastCol = 0;
draw = function() {
    if (y > 0 && y % 410 === 0) {
        x += 100;
        col += 1;
    }

    if (col % 4 === 0 && col !== lastCol) {
        background(255, 255, 255);
        x = 10;
        lastCol = col;
    }
    
    if (col < 4) { area(y, x, y - (410 * col)); }
    else { area(y, x, y - (410 * col)); }

    y += 10;
    debug(col);
};

