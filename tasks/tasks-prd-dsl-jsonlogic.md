## Relevant Files

- `internal/translator/jsonlogic/translator.go` - Core translation logic from DSL to JSONLogic.
- `internal/translator/jsonlogic/translator_test.go` - Unit tests for translation logic.
- `internal/parser/parser.go` - DSL parser implementation and updates for new operations.
- `internal/parser/parser_test.go` - Unit tests for parser.
- `internal/lexer/lexer.go` - Lexer updates for new tokens/operations.
- `internal/lexer/lexer_test.go` - Unit tests for lexer.
- `cmd/cli/commands/translate.go` - CLI command for translating DSL to JSONLogic.
- `cmd/cli/commands/translate_test.go` - Unit tests for CLI.
- `internal/http/server.go` - HTTP API server for translation.
- `internal/http/server_test.go` - Unit tests for HTTP API server.
- `examples/` - Example DSL scripts and their expected JSONLogic outputs.
- `readme.md` - Main documentation for the project.
- `progress.md` - Progress tracking for supported operations and features.

### Notes

- Unit tests should typically be placed alongside the code files they are testing (e.g., `translator.go` and `translator_test.go` in the same directory).
- Use `npx jest [optional/path/to/test/file]` to run tests. Running without a path executes all tests found by the Jest configuration.

## Tasks

- [ ] 1.0 Complete Support for All JSONLogic Operations in the DSL
  - [ ] 1.1 Implement support for `if` logical operation in parser, lexer, ast, and translator.
  - [ ] 1.2 Implement support for `max` and `min` numeric operations.
  - [ ] 1.3 Implement support for string operations: `cat`, `substr`.
  - [ ] 1.4 Implement support for array operations: `map`, `reduce`, `filter`, `all`, `none`, `some`, `merge`.
  - [ ] 1.5 Implement support for miscellaneous operation: `log`.
  - [ ] 1.6 Implement support for multiple operations (translate multiple expressions at once).
  - [ ] 1.7 Implement support for assignment and functions (including `evaluate`).
  - [ ] 1.8 Update progress.md as each operation/feature is completed.

- [ ] 2.0 Implement CLI and HTTP API Server for Rule Translation
  - [ ] 2.1 Design and implement a CLI command to accept DSL input and output JSONLogic.
  - [ ] 2.2 Design and implement an HTTP API server endpoint to accept DSL input and return JSONLogic.
  - [ ] 2.3 Ensure both CLI and HTTP API share core translation logic.
  - [ ] 2.4 Add usage documentation for CLI and HTTP API.

- [ ] 3.0 Improve Error Logging and Tooling
  - [ ] 3.1 Enhance error messages for invalid syntax in the parser and lexer.
  - [ ] 3.2 Add error messages for invalid or unsupported operations.
  - [ ] 3.3 Implement logging for translation errors and edge cases.
  - [ ] 3.4 Add tests for error scenarios and edge cases.

- [ ] 4.0 Documentation and Examples
  - [ ] 4.1 Write documentation for the DSL syntax and supported operations.
  - [ ] 4.2 Provide example DSL scripts and their expected JSONLogic outputs in the `examples/` directory.
  - [ ] 4.3 Update the main `readme.md` with usage instructions and links to examples.
  - [ ] 4.4 Document how to extend the DSL with new operations.

- [ ] 5.0 Testing and Quality Assurance
  - [ ] 5.1 Write unit tests for all new parser, lexer, and translator features.
  - [ ] 5.2 Write integration tests for CLI and HTTP API.
  - [ ] 5.3 Test error handling and edge cases.
  - [ ] 5.4 Review and refactor code for maintainability and clarity.
  - [ ] 5.5 Ensure all tests pass and update progress.md. 

- [ ] 6.0 Release
  - [ ] 6.1 Write github workflow to generate builds
  - [ ] 6.2 Write installation script for easy-installation to mac, linux and windows
  - [ ] 6.3 Write un-installation script for complete removal for mac, linux and windows