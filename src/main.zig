const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();
const testing = std.testing;

var index: usize = 0;

pub fn main() !void {
    var buffer: [256]u8 = undefined;
    const result = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const line = result orelse return;
    try stdout.print("{d}\n", .{readInt(line)});
}

fn readInt(str: []const u8) i32 {
    var result: i32 = str[index] - '0';
    index += 1;
    while (str.len > index and str[index] >= '0' and str[index] <= '9') {
        result = result * 10 + str[index] - '0';
        index += 1;
    }
    return result;
}

test "readInt" {
    index = 0;
    try testing.expectEqual(0, readInt("0"));
    index = 0;
    try testing.expectEqual(1, readInt("1"));
    index = 0;
    try testing.expectEqual(9, readInt("9a"));
    index = 0;
    try testing.expectEqual(10, readInt("10bc"));
    index = 0;
    try testing.expectEqual(11, readInt("11"));
    index = 0;
    try testing.expectEqual(123, readInt("123"));
    index = 2;
    try testing.expectEqual(3, readInt("123"));
}
