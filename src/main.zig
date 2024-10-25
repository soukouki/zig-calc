const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();
const testing = std.testing;

var index: usize = 0;

pub fn main() !void {
    var buffer: [256]u8 = undefined;
    const result = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const line = result orelse return;
    try stdout.print("{d}\n", .{readAddSub(line)});
}

fn readAddSub(str: []const u8) i32 {
    var result: i32 = readMulDiv(str);
    while (str.len > index and (str[index] == '+' or str[index] == '-')) {
        const op = str[index];
        index += 1;
        const next = readMulDiv(str);
        if (op == '+') {
            result += next;
        } else {
            result -= next;
        }
    }
    return result;
}

test "readAddSub" {
    index = 0;
    try testing.expectEqual(1, readAddSub("1"));
    index = 0;
    try testing.expectEqual(3, readAddSub("1+2"));
    index = 0;
    try testing.expectEqual(6, readAddSub("1+2+3"));
    index = 0;
    try testing.expectEqual(1, readAddSub("2-1"));
    index = 0;
    try testing.expectEqual(-1, readAddSub("1-2"));
}

fn readMulDiv(str: []const u8) i32 {
    var result: i32 = readInt(str);
    while (str.len > index and (str[index] == '*' or str[index] == '/')) {
        const op = str[index];
        index += 1;
        const next = readInt(str);
        if (op == '*') {
            result *= next;
        } else {
            // divTruncを使う
            result = @divTrunc(result, next);
        }
    }
    return result;
}

test "readMulDiv" {
    index = 0;
    try testing.expectEqual(1, readMulDiv("1"));
    index = 0;
    try testing.expectEqual(2, readMulDiv("1*2"));
    index = 0;
    try testing.expectEqual(6, readMulDiv("1*2*3"));
    index = 0;
    try testing.expectEqual(2, readMulDiv("2/1"));
    index = 0;
    try testing.expectEqual(0, readMulDiv("1/2"));
    index = 0;
    try testing.expectEqual(5, readAddSub("1*2+3"));
    index = 0;
    try testing.expectEqual(7, readAddSub("1+2*3"));
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
