# Truth::Table

A simple, thrown-together library for displaying a
[truth table](https://en.wikipedia.org/wiki/Truth_table)
for boolean expressions.


## Usage

You can use the provided command-line tool to display an
arbitrary expression:

```sh
$ truth "A && B || C"
Expression:
A && B || C

 A  B  C | =
---------+---
 f  f  f | f
 t  f  f | f
 f  t  f | f
 t  t  f | t
 f  f  t | t
 t  f  t | t
 f  t  t | t
 t  t  t | t
```

Or, you can do it programmatically:

```ruby
require 'truth'

table = Truth::Table.new("A && B || C")
table.display
```

You can also generate
[Karnaugh maps](https://en.wikipedia.org/wiki/Karnaugh_map) (K-maps).
From the command-line, just pass -k to the `truth` tool to have it
display both the truth table and the K-map:

```sh
$ truth -k "A && B || C"
Expression:
A && B || C

 A  B  C | =
---------+---
 f  f  f | f
 t  f  f | f
 f  t  f | f
 t  t  f | t
 f  f  t | t
 t  f  t | t
 f  t  t | t
 t  t  t | t

     AB
     00 01 11 10
    +--+--+--+--+
C 0 |0 |0 |1 |0 |
    +--+--+--+--+
  1 |1 |1 |1 |1 |
    +--+--+--+--+
```

Or, programmatically:

```ruby
require 'truth'

table = Truth::Table.new("A && B || C")
table.kmap.display
```


## Supported Operations

The parser is simplistic, but supports the following boolean operations:

* NOT: `!A`
* AND: `A && B`
* OR: `A || B`
* XOR: `A ^^ B`

The `||` and `^^` operators have the same precedence, with `&&` being
higher than either, and `!` being highest of all.

Parentheses may be used to group expressions.


## Caveats

This was thrown together as a proof of concept, and is being made public
primarily because I spent time on it and figured it might help someone
else. There are not currently any tests (shame on me!) but I would gladly
accept a pull request if someone is feeling ambitious.


## License

This code is written by Jamis Buck <jamis@jamisbuck.org> and is
distributed under the MIT license (see the MIT-LICENSE file).
