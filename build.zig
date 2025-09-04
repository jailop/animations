const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "movingbox",
        .root_source_file = b.path("./src/movingbox.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.linkSystemLibrary("raylib");
    exe.linkSystemLibrary("m");
    exe.linkSystemLibrary("dl");
    exe.linkSystemLibrary("pthread");
    exe.linkSystemLibrary("GL");
    exe.linkSystemLibrary("X11");
    b.installArtifact(exe);
    const runCmd = b.addRunArtifact(exe);
    runCmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        runCmd.addArgs(args);
    }
    b.step("run", "Build and run").dependOn(&runCmd.step);
}
