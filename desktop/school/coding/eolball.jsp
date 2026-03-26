var ball = {
    x: 0,
    y: 0,
    yInt: 200,
    vx: 0,
    vy: 0,
    bounces: 0,
    r: 15,
    consumed: false
};

ball.og = {
    x: ball.x,
    y: ball.y,
    yInt: ball.yInt
};

var blackhole = {
    x: 200,
    y: 200,
    r: 200
};

var slope, eol;
var base = {
    1: { x: null, obtained: false },
    2: { x: null, obtained: false },
    3: { x: null, obtained: false }
};

var dx = blackhole.x - ball.x;
var dy = blackhole.y - ball.y;
var distance = sqrt((dx * dx) + (dy * dy));

var speed = 1, direction = 1, foo = 0;

draw = function() {
    if (!ball.consumed) { ellipse(blackhole.x, blackhole.y, blackhole.r, blackhole.r); }

    ellipse(blackhole.x, blackhole.y, 3, 3);

    dx = blackhole.x - ball.x;
    distance = sqrt((dx * dx) + (dy * dy));

    if (distance < (blackhole.r / 2) + 75) {
        var forceX = dx / distance;
        var forceY = dy / distance;
        var strength = 2 / distance;

        ball.vx += forceX * strength;
        ball.vy += forceY * strength;
    }

    ball.x += ball.vx;
    ball.y += ball.vy;

    debug(distance);
    if (distance < blackhole.r / 2) {
        ball.consumed = true;
        ellipse(blackhole.x, blackhole.y, blackhole.r + ball.r, blackhole.r + ball.r);
    }

    if (!ball.consumed) {
        if (ball.bounces < 3) {
            if (ball.x > width) {
                direction = -1;
                ball.bounces += 1;
            } else if (ball.x < 0) {
                direction = 1;
                ball.bounces += 1;
            } else if (ball.y === height) { ball.bounces += 1; }
            else if (ball.y < 0) { ball.bounces += 1; }
        }

        if (direction === 1) {
            ball.x += speed + ball.vx;
            foo += ball.bounces === 3 ? -speed : speed;
            ball.y = foo + ball.yInt;

            slope = (ball.y - ball.yInt) / ball.x;
            eol = (slope * ball.x) + ball.yInt;
            dy = blackhole.y - eol;

            if (ball.bounces === 3) {
                if (!base[3].obtained) {
                    base[3].x = ball.x;
                    base[3].obtained = true;
                }

                slope = (ball.y - ball.yInt) / ball.x;
                var x_delta = base[3].x + ball.x;
                eol = (slope * x_delta);
                dy = blackhole.y - eol;

                point(ball.x, eol);
            } else if (ball.x > 0) {
                if (ball.y < width - ball.og.x && ball.y < height) { ellipse(ball.x, eol, ball.r, ball.r); }
                else {
                    if (!base[1].obtained) {
                        base[1].x = ball.x;
                        base[1].obtained = true;
                    }

                    slope = (ball.y - ball.yInt) / ball.x;
                    var x_delta = base[1].x - (ball.x - base[1].x);
                    eol = (slope * x_delta) + ball.yInt;
                    dy = blackhole.y - eol;

                    ellipse(ball.x, eol, ball.r, ball.r);
                }
            }
        } else if (direction === -1) {
            ball.x -= speed;
            foo += ball.bounces === 2 ? -1 : 1;
            ball.y = foo - ball.yInt;

            slope = (ball.y - ball.yInt) / ball.x;
            eol = (slope * ball.x) + ball.yInt;
            dy = blackhole.y - eol;

            if (ball.y < height) {
                if (ball.y > 0) { ellipse(ball.x, eol, ball.r, ball.r); }
                else if (ball.x >= 0) {
                    if (!base[2].obtained) {
                        base[2].x = ball.x;
                        base[2].obtained = true;
                    }

                    slope = (-ball.y - ball.yInt) / -ball.x;
                    var x_delta = base[2].x - ball.x;
                    eol = (slope * x_delta);
                    dy = blackhole.y - eol;

                    ellipse(ball.x, eol, ball.r, ball.r);
                }
            }
        }
    }
};
