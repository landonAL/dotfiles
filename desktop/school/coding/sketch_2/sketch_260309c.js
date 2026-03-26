class ball {
    constructor(x, y, rad, vx, vy) {
        this.x = x;
        this.y = y;
        this.rad = rad;
        this.vx = vx;
        this.vy = vy;
        this.a = Math.PI * (rad * rad);
    }

    move() {
        this.x += this.vx;
        this.y += this.vy;
    }

    draw() {
        fill(0);
        ellipse(this.x, this.y, this.rad * 2, this.rad * 2);
    }

    bounce() {
        if (this.x - this.rad < 0 || this.x + this.rad > x) this.vx = -this.vx;
        if (this.y - this.rad < 0 || this.y + this.rad > y) this.vy = -this.vy;
    }

    debug() {
        text("x=" + this.x + "\ny=" + this.y + "\nrad=" + this.rad + "\nvx=" + this.vx + "\nvy=" + this.vy, this.x - 15, this.y - this.rad - 70);
    }
}

let balls = [];
let x = 400, y = 400;

function setup() {
    createCanvas(x, y);

    balls = [
        new ball(100, 100, 30, 1, 1)
    ];
}

function draw() {
    background(255);
    fill(255);
    rect(0, 0, x, y);

    for (let i = 0; i < balls.length; i++) {
        let b = balls[i];

        b.move();
        b.draw();
        b.bounce();
        b.debug();
    }
}
