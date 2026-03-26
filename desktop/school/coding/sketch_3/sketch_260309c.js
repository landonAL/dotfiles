class lines {
    constructor(x) {
        this.x = x;
        this.y = x;
    }

    draw(i) {
        let foo = this.x;
        let angleStep = Math.PI / 180;

        switch (i) {
            case 1:
                line(this.x, 400, 0, this.y);
                break;

            case 2:
                line(400, this.y, 400 - this.x, 400);
                break;

            case 3:
            line(400 - this.x, 0, 400, 400 - this.y); 
                break;

            case 4:
                line(0, this.y, 400 - this.x, 0);
                break;
        }

        if (foo <= 200) {
            for (let j = 0; j < 360; ++j) {
                let angle = j * angleStep;

                this.x *= Math.cos(angle);
                this.y *= Math.sin(angle);
            }

            switch (i) {
                case 1:
                    line(200, this.y, 200 - this.x, 200);
                    break;

                case 2:
                    line(200, 400 - this.y, 200 - this.x, 200);
                    break;

                case 3:
                    line(200, 400 - this.y, 200 + this.x, 200);
                    break;

                case 4:
                    line(200, this.y, 200 + this.x, 200);
                    break;
            }
        } else foo -= 200;
    }

    move(x) {
        this.x = x;
        this.y = x;
    }
}

let x = 400, y = 400;
let mainLine, lineX = 0;
let foo = 1;

function setup() {
    createCanvas(x, y);
    mainLine = new lines(lineX);

    rect(0, 0, x, y);
}

function draw() {
    mainLine.draw(foo);
    foo += 1;

    lineX += 10;
    mainLine.move(lineX);
}
