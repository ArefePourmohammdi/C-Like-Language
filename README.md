# N++ Language Parser

## Description
This task implements a Flex-Bison parser for a simplified programming language called **N++**. The language supports variable declarations, assignments, control flow structures (`if-else` and `while`), and various operators including arithmetic, relational, logical, and bitwise.

## Features
- Supports **data types**: `int`, `float`, `bool`.
- Variable declarations with **comma-separated multiple variables** (e.g., `int x, y, z;`).
- **Assignment chaining** is allowed (e.g., `x = y = 2;`).
- Control flow:
  - **If-else statements**: Allows block code execution based on conditions.
  - **While loops**: Iterates over blocks of code based on conditions.
- Operators supported:
  - **Arithmetic**: `+`, `-`, `*`, `/`, `%`
  - **Relational**: `<`, `>`, `<=`, `>=`, `==`, `!=`
  - **Logical**: `&&`, `||`, `!`
  - **Bitwise**: `&`, `|`, `^`, `~`
  - **Parentheses**: `()`
  


