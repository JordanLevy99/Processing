class Walker {
int x;
int y;

Walker() {
        x = width/2;
        y = height/2;
}

void display() {
        stroke(0);
        point(x,y);
}

void step() {
        //generate a value between 0 and 1
        float r = random(1);
        if(r < 0.4) {
                x++;
        } else if(r < 0.6) {
                x--;
        } else if(r < 0.8) {
                y++;
        } else {
                y--;
        }
}
}