var ball = {
    x: 0,
    y: 0,
    yInt: 100,
    bounces: 0
};

ball.og = {
    x: ball.x,
    y: ball.y,
    yInt: ball.yInt
};

var slope, eol;
var base = {
    1: { x: null, obtained: false },
    2: { x: null, obtained: false },
    3: { x: null, obtained: false }
};

var speed = 1, direction = 1, foo = 0;

draw = function() {
    // HARDCODED VERSION

    // if (!invert) {
    //     ball.x += direction;
    //     ball.y = ball.x + 100;

    //     if (ball.x < 400) {
    //         if (ball.y < 400) { point(ball.x, ball.x + 100); } // y = x + 100 (line 1)
    //         else { point(ball.x, -ball.x + 700); } // y = -x + 700 (line 2)

    //     } else { invert = true; }
    // } else {
    //     ball.x -= direction;
    //     ball.y = ball.x - 100;

    //     if (ball.y < 400) {
    //         if (ball.y >= 0) { point(ball.x, ball.x - 100); } // y = x - 100 (line 3)
    //         else if (ball.x >= 0) { point(ball.x, -ball.x + 100); } // y = -x + 100 (line 4)
    //     }
    // }

    // y = mx + b
    // m = (y2-y1)/(x2-x1) or (y - b) / x
    // y2 or y1 = m(x2 or x1) + b

    // AUTOMATED VERSION

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
        ball.x += speed;
        foo += ball.bounces === 3 ? -speed : speed;
        ball.y = foo + ball.yInt;

        slope = (ball.y - ball.yInt) / ball.x;
        eol = (slope * ball.x) + ball.yInt;

        if (ball.bounces === 3) {
            if (!base[3].obtained) {
                base[3].x = ball.x;
                base[3].obtained = true;
            }

            slope = (ball.y - ball.yInt) / ball.x;
            var x_delta = base[3].x + ball.x;
            eol = (slope * x_delta);
            point(ball.x, eol);
        } else if (ball.x > 0) {
            if (ball.y < width - ball.og.x && ball.y < height) { point(ball.x, eol); }
            else {
                if (!base[1].obtained) {
                    base[1].x = ball.x;
                    base[1].obtained = true;
                }

                slope = (ball.y - ball.yInt) / ball.x;
                var x_delta = base[1].x - (ball.x - base[1].x);
                eol = (slope * x_delta) + ball.yInt;
                point(ball.x, eol);
            }
        }
    } else if (direction === -1) {
        ball.x -= speed;
        foo += ball.bounces === 2 ? -1 : 1;
        ball.y = foo - ball.yInt;

        slope = (ball.y - ball.yInt) / ball.x;
        eol = (slope * ball.x) + ball.yInt;
        //debug(ball.y);

        if (ball.y < height) {
            if (ball.y > 0) { point(ball.x, eol); }
            else if (ball.x >= 0) {
                if (!base[2].obtained) {
                    base[2].x = ball.x;
                    base[2].obtained = true;
                }

                slope = (-ball.y - ball.yInt) / -ball.x;
                var x_delta = base[2].x - ball.x;
                eol = (slope * x_delta);
                point(ball.x, eol);
            }
        }
    }
};
