/// This an example of a basic simulation setup.  The model is a entity
/// (actually, a box) that is moving around the window. The mechanism is
/// conformed by a step and a direction.  The window works as the context, that
/// at the same time marks the frotier of the model.
///
/// To implement this example, the `raylib` library has been used.  If you want
/// to compile directly this file, use the following command:
///
/// ```sh
/// zig build-exe movingbox.zig -lraylib -lm -ldl -lpthread -lGL -lX11
/// ```
///
/// Otherwise, if you have clone the repository, just run `zig build`.
///
/// There is a video in which this code was used as an example:
///
/// https://www.youtube.com/watch?v=KUcEGgAWxeE&t=33s
///
/// Copyright (c) 2025 Jaime Lopez - MIT License

const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});

/// Pair represents a point in a bidimensional space. It is used as a brick to
/// build composed shapes, like lines and rectangles.
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
    step: i32,        // how far the box moves in each step
    dim: i32,         // a size for the height and width of the box
    win: Pair,        // Width and height of the window, the frontier
    box: Rect,        // The like-agent in this model, a box
    direction: Pair,  //  1 indicates moving from left to right, top to botton
                      // -1 indicates moving from right to left, botton to top

    /// The creation of the simulation and the setup of its initial conditions
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

    /// The window acts as the frontier of the model. The box cannot go beyond
    /// the window. When a border is reached by the box, the direction is
    /// switched.
    fn updateDirection(self: *Simulation) void {
        if (self.box.pos.x + self.box.dim.x >= self.win.x)
            // It reached the right border
            self.direction.x = -1
        else if (self.box.pos.x <= 0)
            // It reached the left border
            self.direction.x = 1;
        if (self.box.pos.y + self.box.dim.y >= self.win.y)
            // It reached the botton border
            self.direction.y = -1
        else if (self.box.pos.y <= 0)
            // It reached the top border
            self.direction.y = 1;
    }

    /// Updating the model. If the box has reached any of the borders,
    /// directions are updated and a new positon for the box is assigned.
    pub fn update(self: *Simulation) void {
        self.updateDirection();
        // x and y positions are updated
        self.box.pos.x += self.direction.x * self.step;
        self.box.pos.y += self.direction.y * self.step;
    }

    /// Output for this model is a visualization. The box and a line from the
    /// center of the window to center of the box are drawn in each step of the
    /// simulation.
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
    // Simulation initialization. It includes the low level stuff of creating
    // the window and setting the frame rate.
    var sim = Simulation.init(10, 50);
    rl.InitWindow(sim.win.x, sim.win.y, "Moving Box");
    defer rl.CloseWindow();
    rl.SetTargetFPS(20);
    // The loop in which the simulation evolves
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        sim.update();
        sim.draw();
        rl.EndDrawing();
    }
}
