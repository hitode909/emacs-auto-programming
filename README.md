# auto-programming.el

The Auto Programming Solution

![](http://i.gyazo.com/4037e1526cbb23e2e8042b39e250eff5.gif)

## How To Use

Write some code and execute `auto-programming`.
You will get candidates of next line of your program.

For example, you type `use stri`, the code you want to get is `use strict;`, and the next line is `use warnings`.

## How It Works

For example, when you write `use stri` and execute `auto-programming`,

1. git grep `use stri`
2. Collect the result of git grep
3. Show the result in editor
4. Replace the current line with the selected result


## Requirements

- Git
- Perl
