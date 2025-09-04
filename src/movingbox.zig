const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});

const Pair = struct {
    x: i32 = 0,
    y: i32 = 0,
};

const Line = struct {
    start: Pair = Pair{},
    end: Pair = Pair{},
    pub fn draw(self: Line) void {
        rl.DrawLine(
            self.start.x,
            self.start.y,
            self.end.x,
            self.end.y,
            rl.DARKGRAY
        );
    }
};

const Rect = struct {
    pos: Pair = Pair{},
    dim: Pair = Pair{},
    pub fn draw(self: Rect) void {
        rl.DrawRectangle(
            self.pos.x,
            self.pos.y,
            self.dim.x,
            self.dim.y,
            rl.DARKGRAY
        );
    }
};

const win = Pair{.x=640, .y=480};

pub fn main() void {
    rl.InitWindow(win.x, win.y, "Moving Box");
    rl.SetTargetFPS(120);
    var x: i32 = 10;
    var y: i32 = 10;
    var xdir: i32 = 1;
    var ydir: i32 = 1;
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.RAYWHITE);
        const box = Rect{
            .pos=.{.x=x, .y=y},
            .dim=.{.x=50, .y=50},
        };
        if (x > win.x - 60) xdir = -1;
        if (x < 10) xdir = 1;
        if (y > win.y - 60) ydir = -1;
        if (y < 10) ydir = 1;
        x += xdir * 10;
        y += ydir * 10;
        box.draw();
        const line = Line{
            .start=.{.x=win.x / 2, .y=win.y / 2},
            .end=.{.x=x + 25, .y=y + 25}};
        line.draw();
        rl.EndDrawing();
    }
    defer rl.CloseWindow();
}
