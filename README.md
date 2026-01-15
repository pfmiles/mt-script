NOTEZ: THIS IS UNDER HEAVY DEVELOPMENT AND IS NOT READY FOR USE, COME BACK LATER IF INTERESTED!!!

# mt-script
A rule-definition-style syntax, extensible scripting language and its execution engine.

## Project Structure

```
mt-script/
├── src/             # Source code directory
│   ├── mt_script.lua     # Entry point of the mt-script language
│   ├── lexer.lua        # Lexical analyzer
│   ├── parser.lua       # Syntax parser
│   ├── evaluator.lua    # AST evaluator/interpreter
│   ├── data_structure.lua # Core data structures
│   └── reference_table.lua # Reference table definitions
├── test/            # Test directory
│   ├── lexer_tests.lua   # Lexer tests
│   ├── parser_tests.lua  # Parser tests
│   └── evaluator_tests.lua # Evaluator tests
├── README.md        # Project documentation
└── LICENSE          # License file
```

## Development Environment

This project is written in Lua and can be run with any Lua interpreter (version 5.1 or later recommended).

## Project Components

### Entry Point (mt_script.lua)
Main entry point of the mt-script language, coordinating the lexical analysis, parsing, and evaluation phases.

### Lexical Analyzer (lexer.lua)
Responsible for converting source code into a token stream, supporting identification of identifiers, keywords, numbers, operators, and punctuation.

### Syntax Parser (parser.lua)
Responsible for converting token streams into an Abstract Syntax Tree (AST), supporting syntax structures such as assignments, function definitions, conditional statements, and loop statements.

### Evaluator (evaluator.lua)
Responsible for executing the Abstract Syntax Tree, implementing functionality such as variable assignments, function calls, conditional judgments, and loop execution.

### Data Structures (data_structure.lua)
Contains core data structures used throughout the interpreter.

### Reference Table (reference_table.lua)
Defines a table containing all referable key-value pairs, determining which values and functions can be directly referenced in scripts.

## Test Framework

The project includes separate test files for each component, located in the test/ directory. Each test file tests the corresponding component functionality.

## Usage

Run the mt-script language using the main entry point:

```bash
lua src/mt_script.lua
```

## Development Guide

### Adding New Syntax

1. Add new token types in the lexical analyzer (lexer.lua)
2. Add new syntax rules in the syntax parser (parser.lua)
3. Add corresponding execution logic in the evaluator (evaluator.lua)
4. Write unit tests in the appropriate test file

### Debugging Tips

- Use print statements to output variable values
- Write unit tests to verify functionality correctness

## License

This project is licensed under the MIT License. See the LICENSE file for details.
