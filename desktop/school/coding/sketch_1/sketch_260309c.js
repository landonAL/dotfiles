class tri {
    constructor(x, y, x2, y2, x3, y3, vx, vy, r, g, b) {
        this.x = x;
        this.y = y;
        this.x2 = x2;
        this.y2 = y2;
        this.x3 = x3;
        this.y3 = y3;
        this.vx = vx;
        this.vy = vy;
        this.r = r;
        this.g = g;
        this.b = b;
    }

    move() {
        this.x += this.vx;
        this.y += this.vy;

        this.x2 += this.vx;
        this.y2 += this.vy;

        this.x3 += this.vx;
        this.y3 += this.vy;
    }

    draw() {
        fill(this.r, this.g, this.b);
        triangle(this.x, this.y, this.x2, this.y2, this.x3, this.y3);
    }
}

let triangles = [];

class ball {
    constructor(x, y, w, h, rad, vx, vy, r, g, b, exploded, defX, defY, defVX, defVY) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.rad = rad;
        this.vx = vx;
        this.vy = vy;
        this.a = Math.PI * (rad * rad);
        this.r = r;
        this.g = g;
        this.b = b;
        this.exploded = exploded;
        this.defX = defX;
        this.defY = defY;
        this.defVX = defVX;
        this.defVY = defVY;
        this.currentDef = 0;
        this.targetDef = 4;
        this.shapeX = 1;
        this.shapeY = 1;
        this.targetShapeX = 1;
        this.targetShapeY = 1;
        this.forceX = 0;
        this.forceY = 0;
        this.stiffness = 0.5;
    }

    move() {
        this.x += this.vx;
        this.y += this.vy;
    }

    color() {
        this.r = Math.random() * 255;
        this.g = Math.random() * 255;
        this.b = Math.random() * 255;
    }

    distance() {
        let dx = Math.abs(mouseX - this.x);
        let dy = Math.abs(mouseY - this.y);
        return Math.sqrt(dx * dx + dy * dy);
    }

    ballDistance(ball) {
        let dx = Math.abs(ball.x - this.x);
        let dy = Math.abs(ball.y - this.y);
        return Math.sqrt(dx * dx + dy * dy);
    }

    explode(ball) {
        if (ball === this) return;

        let speed = Math.sqrt(this.vx * this.vx + this.vy * this.vy);
        let ballSpeed = Math.sqrt(ball.vx * ball.vx + ball.vy * ball.vy);

        let bx = this.x, by = this.y, br = this.rad;
        let r = 0, g = 0, b = 0;

        // triangles:
        // 1 - (b.x + halfWidth, b.y - height)
        // 2 - (b.x + (halfWidth * 2), b.y)
        // 3 - (b.x + (halfWidth * 2), b.y + height)
        // 4 - (b.x - halfWidth, b.y + height)
        // 5 - (b.x - (halfWidth * 2), b.y)
        // 6 - (b.x - halfWidth, b.y - height)

        if (this.ballDistance(ball) <= this.rad * 2) {
            if (this.r > ball.r && speed > ballSpeed) {
                bx = ball.x += 1;
                by = ball.y += 1;
                br = ball.rad;
                r = ball.r;
                g = ball.g;
                b = ball.b;
                ball.exploded = true;
            } else if ((this.r == ball.r && speed == ballSpeed) || (this.r < ball.r && speed > ballSpeed) || (this.r > ball.r && speed < ballSpeed)) {
                if (Math.random() > 0.5) {
                    bx = this.x += 1;
                    by = this.y += 1;
                    br = this.rad;
                    r = this.r;
                    g = this.g;
                    b = this.b;
                    this.exploded = true;
                } else {
                    bx = ball.x += 1;
                    by = ball.y += 1;
                    br = ball.rad;
                    r = ball.r;
                    g = ball.g;
                    b = ball.b;
                    ball.exploded = true;
                }
            } else if (this.r < ball.r && speed < ballSpeed) {
                bx = this.x += 1;
                by = this.y += 1;
                br = this.rad;
                r = this.r;
                g = this.g;
                b = this.b;
                this.exploded = true;
            }

            if (this.exploded || ball.exploded) {
                for (let i = 0; i < 6; i++) {
                    let a1 = i * angleStep;
                    let a2 = (i + 1) * angleStep;

                    let x1 = bx + br * Math.cos(a1);
                    let y1 = by + br * Math.sin(a1);

                    let x2 = bx + br * Math.cos(a2);
                    let y2 = by + br * Math.sin(a2);

                    let vx = Math.cos(a1) * 7;
                    let vy = Math.sin(a1) * 7;

                    triangles.push(new tri(bx, by, x1, y1, x2, y2, vx, vy, r, g, b));
                }
            }
        }
    }

    draw() {
        fill(this.r, this.g, this.b);
        ellipse(this.x, this.y, this.w * this.shapeX, this.h * this.shapeY);
    }

    area() {
        text(this.a, 50, 50);
    }

    bounce() {
        let crushX = false, crushY = false, damping = 0.9;

        if (this.x - this.rad < 0 || this.x + this.rad > x) {
            this.color();
            this.vx = -this.vx;
            crushX = true;
        }

        if (this.y - this.rad < 0 || this.y + this.rad > y) {
            this.color();
            this.vy = -this.vy;
            crushY = true;
        }

        if (crushX) {
            this.targetShapeY = 0.5;
            crushX = false;
        } else this.targetShapeY = 1;

        if (crushY) {
            this.targetShapeX = 0.5;
            crushY = false;
        } else this.targetShapeX = 1;

        this.forceX = this.stiffness * (this.targetShapeX - this.shapeX);
        this.defVX = (this.defVX + this.forceX) * damping;
        this.shapeX += this.defVX;

        this.forceY = this.stiffness * (this.targetShapeY - this.shapeY);
        this.defVY = (this.defVY + this.forceY) * damping;
        this.shapeY += this.defVY;
    }
}

let balls = [];
let x = 400, y = 400;
let angleStep = (Math.PI * 2) / 6;

function setup() {
    createCanvas(x, y);

    balls = [
        new ball(100, 100, 60, 60, 30, 10, 1, 255, 255, 255, false, 0, 0, 0, 0),
        // new ball(200, 200, 60, 60, 30, 2, 1, 255, 255, 255, false, 0, 0, 0, 0),
        // new ball(200, 230, 56, 56, 28, 1, 1, 255, 255, 255, false, 0, 0, 0, 0)
    ];
}

function draw() {
    background(255);
    fill(255);
    rect(0, 0, x, y);

    for (let i = 0; i < balls.length; i++) {
        let b = balls[i];

        if (!b.exploded) {
            b.move();
            fill(255);
            b.draw();

            if (b.distance() < b.rad) {
                fill(0);
                text(b.a, b.x - b.rad, b.y - b.rad - 5);
            }

            b.bounce();

            for (let j = i + 1; j < balls.length; j++) {
                let b2 = balls[j];
                if (!b.exploded && !b2.exploded) b.explode(b2);
            }
        }
    }

    for (let t of triangles) {
        t.move();
        fill(0);
        t.draw();
    }
}
