var ball = {
    x: 0,
    y: 0,
    r: 40,
};

var secondBall = {
    x: 0,
    y: 0,
    r: ball.r
};

var unitX = 0, unitY = 0;
var lastUnitX = 0, lastUnitY = 0;

draw = function() {
    background(255, 255, 255);

    ball.x = mouseX;
    ball.y = mouseY;

    var dx = mouseX - pmouseX;
    var dy = mouseY - pmouseY;

    var distance = sqrt((dx * dx) + (dy * dy));
    if (distance > 0) {
        unitX = dx / distance;
        unitY = dy / distance;
        
        lastUnitX = unitX;
        lastUnitY = unitY;
    } else {
        unitX = lastUnitX;
        unitY = lastUnitY;
    }
    
    secondBall.x = ball.x - (unitX * ball.r);
    secondBall.y = ball.y - (unitY * ball.r);
    
    fill(0);
    ellipse(ball.x, ball.y, ball.r, ball.r);
    ellipse(secondBall.x, secondBall.y, secondBall.r, secondBall.r);
};

