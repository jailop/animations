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
            rl.WHITE
        );
    }
};

const Rect = struct {
    pos: Pair = Pair{},  // position
    dim: Pair = Pair{},  // dimensions

    pub fn draw(self: Rect) void {
        rl.DrawRectangle(
            self.pos.x,
            self.pos.y,
            self.dim.x,
            self.dim.y,
            rl.WHITE
        );
    }

    pub fn center(self: Rect) Pair {
        return .{
            .x=self.pos.x + @divFloor(self.dim.x, 2),
            .y=self.pos.y + @divFloor(self.dim.y, 2),
        };
    }
};

const Simulation = struct {
    step: i32,
    dim: i32,
    win: Pair,
    box: Rect,
    direction: Pair,

    pub fn init(step: i32, dim: i32) Simulation {
        return .{
            .step = step,
            .dim = dim,
            .win = .{.x = 640, .y = 480},
            .box = .{
                .pos = .{.x = 0, .y = 0},
                .dim = .{.x = dim, .y = dim},
            },
            .direction = .{.x = 1, .y = 1},
        };
    }

    fn updateDirection(self: *Simulation) void {
        if (self.box.pos.x + self.box.dim.x >= self.win.x)
            self.direction.x = -1
        else if (self.box.pos.x <= 0)
            self.direction.x = 1;
        if (self.box.pos.y + self.box.dim.y >= self.win.y)
            self.direction.y = -1
        else if (self.box.pos.y <= 0)
            self.direction.y = 1;
    }

    pub fn update(self: *Simulation) void {
        self.updateDirection();
        self.box.pos.x += self.direction.x * self.step;
        self.box.pos.y += self.direction.y * self.step;
    }

    pub fn draw(self: Simulation) void {
        const line = Line{
            .start = .{
                .x = @divFloor(self.win.x, 2),
                .y = @divFloor(self.win.y, 2),
            },
            .end = self.box.center(),
        };
        line.draw();
        self.box.draw();
    }
};

pub fn main() void {
    var sim = Simulation.init(10, 50);
    rl.InitWindow(sim.win.x, sim.win.y, "Moving Box");
    defer rl.CloseWindow();
    rl.SetTargetFPS(20);
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        sim.update();
        sim.draw();
        rl.EndDrawing();
    }
}
