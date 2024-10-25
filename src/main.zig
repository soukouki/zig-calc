const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var buffer: [256]u8 = undefined;
    const result = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const line = result orelse return;
    try stdout.print("{s}\n", .{line});
}
