class Point {
    constructor(x, y, vx, vy) {
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
    }

    move() {
        this.x += this.vx;
        this.y += this.vy;
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

    draw() {
        point(this.x, this.y);
    }
}

let balls = [];
let x = 400, y = 400;
let xCoor = 0, yCoor = 0;

function setup() {
    createCanvas(x, y);

    points = [
        // new Point(10, 10, 1, 1),
        // new Point(300, 200, 1, 1),
        // new Point(50, 300, 1, 1),
        // new Point(200, 200, 1, 1)
    ];
}

function draw() {
    background(255);
    fill(255);
    rect(0, 0, x, y);

    for (let i = 0; i < 20; i++) {
        points.pop(points[i]);
        xCoor = floor(random(50, 350));
        yCoor = floor(random(50, 350));
        points.push(new Point(xCoor, yCoor, 1, 1));
    }

    for (let i = 0; i < points.length; i++) {
        let p = points[i];

        // p.move();
        // fill(255);
        p.draw();

        if (millis() % 200 < 20) {
            let next = (i + 1) % points.length;
            line(p.x, p.y, points[next].x, points[next].y);
        }
    }
}
