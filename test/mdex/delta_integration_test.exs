defmodule MDEx.DeltaIntegrationTest do
  use ExUnit.Case, async: true

  @extension [
    strikethrough: true,
    tagfilter: true,
    table: true,
    autolink: true,
    tasklist: true,
    superscript: true,
    subscript: true,
    footnotes: true,
    description_lists: true,
    front_matter_delimiter: "---",
    multiline_block_quotes: true,
    math_dollars: true,
    math_code: true,
    shortcodes: true,
    underline: true,
    spoiler: true,
    greentext: true
  ]

  # Helper function to parse with all extensions enabled
  defp parse_with_extensions(markdown) do
    MDEx.to_delta(markdown, extension: @extension)
  end

  describe "real-world document conversion" do
    test "converts complex README-style document" do
      input = """
      # Project Title

      A brief description of what this project does and who it's for.

      ## Installation

      Install using your package manager:

      ```bash
      npm install my-package
      ```

      ## Usage

      Here's a **simple** example:

      ```javascript
      const myPackage = require('my-package');
      console.log(myPackage.hello());
      ```

      ### Features

      - [x] Feature 1: Does something great
      - [x] Feature 2: Also amazing
      - [ ] Feature 3: Coming soon

      ## Contributing

      1. Fork the repository
      2. Create your feature branch (`git checkout -b feature/amazing-feature`)
      3. Commit your changes (`git commit -m 'Add amazing feature'`)
      4. Push to the branch (`git push origin feature/amazing-feature`)
      5. Open a Pull Request

      > **Note**: Please make sure to update tests as appropriate.

      ## License

      This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.
      """

      {:ok, result} = parse_with_extensions(input)

      expected = [
        %{"insert" => "Project Title"},
        %{"attributes" => %{"header" => 1}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "A brief description of what this project does and who it's for."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Installation"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Install using your package manager:"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "npm install my-package\n"},
        %{"attributes" => %{"code-block" => true, "code-block-lang" => "bash"}, "insert" => "\n"},
        %{"insert" => "Usage"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Here's a "},
        %{"attributes" => %{"bold" => true}, "insert" => "simple"},
        %{"insert" => " example:"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "const myPackage = require('my-package');\nconsole.log(myPackage.hello());\n"},
        %{"attributes" => %{"code-block" => true, "code-block-lang" => "javascript"}, "insert" => "\n"},
        %{"insert" => "Features"},
        %{"attributes" => %{"header" => 3}, "insert" => "\n"},
        %{"insert" => "Feature 1: Does something great"},
        %{"attributes" => %{"list" => "bullet", "task" => true}, "insert" => "\n"},
        %{"insert" => "Feature 2: Also amazing"},
        %{"attributes" => %{"list" => "bullet", "task" => true}, "insert" => "\n"},
        %{"insert" => "Feature 3: Coming soon"},
        %{"attributes" => %{"list" => "bullet", "task" => false}, "insert" => "\n"},
        %{"insert" => "Contributing"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "Fork the repository"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Create your feature branch ("},
        %{"insert" => "git checkout -b feature/amazing-feature", "attributes" => %{"code" => true}},
        %{"insert" => ")"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Commit your changes ("},
        %{"attributes" => %{"code" => true}, "insert" => "git commit -m 'Add amazing feature'"},
        %{"insert" => ")"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Push to the branch ("},
        %{"attributes" => %{"code" => true}, "insert" => "git push origin feature/amazing-feature"},
        %{"insert" => ")"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Open a Pull Request"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"attributes" => %{"bold" => true}, "insert" => "Note"},
        %{"insert" => ": Please make sure to update tests as appropriate."},
        %{"attributes" => %{"blockquote" => true}, "insert" => "\n"},
        %{"insert" => "License"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "This project is licensed under the "},
        %{"attributes" => %{"link" => "LICENSE"}, "insert" => "MIT License"},
        %{"insert" => " - see the LICENSE file for details."},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "converts blog post with various formatting" do
      input = """
      # The Future of Web Development

      *Published on January 15, 2025*

      Web development has come a **long way** since the early days of static HTML pages. Today, we're seeing incredible innovations in:

      1. **Frontend Frameworks**
         - React with hooks and concurrent features
         - Vue.js 3 with composition API
         - Svelte's compile-time optimizations

      2. **Backend Technologies**
         - Serverless functions
         - Edge computing
         - GraphQL APIs

      ## Code Examples

      Here's how you might implement a modern React hook:

      ```jsx
      import { useState, useEffect } from 'react';

      function useCounter(initialValue = 0) {
        const [count, setCount] = useState(initialValue);

        useEffect(() => {
          document.title = `Count: ${count}`;
        }, [count]);

        return [count, setCount];
      }
      ```

      ### Mathematical Concepts

      The time complexity can be expressed as O(n²), where *n* represents the input size.

      ## Images and Links

      ![Modern Development](https://example.com/dev-image.png "Development Workflow")

      For more information, check out [this comprehensive guide](https://example.com/guide) on modern web development practices.

      ---

      *What do you think about these trends? Share your thoughts in the comments below.*
      """

      {:ok, result} = parse_with_extensions(input)

      expected = [
        %{"insert" => "The Future of Web Development"},
        %{"insert" => "\n", "attributes" => %{"header" => 1}},
        %{"insert" => "\n"},
        %{"insert" => "Published on January 15, 2025", "attributes" => %{"italic" => true}},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Web development has come a "},
        %{"insert" => "long way", "attributes" => %{"bold" => true}},
        %{"insert" => " since the early days of static HTML pages. Today, we're seeing incredible innovations in:"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Frontend Frameworks", "attributes" => %{"bold" => true}},
        %{"insert" => "\n", "attributes" => %{"list" => "ordered"}},
        %{"insert" => "React with hooks and concurrent features"},
        %{"insert" => "\n", "attributes" => %{"indent" => 1, "list" => "bullet"}},
        %{"insert" => "Vue.js 3 with composition API"},
        %{"insert" => "\n", "attributes" => %{"indent" => 1, "list" => "bullet"}},
        %{"insert" => "Svelte's compile-time optimizations"},
        %{"insert" => "\n", "attributes" => %{"indent" => 1, "list" => "bullet"}},
        %{"insert" => "Backend Technologies", "attributes" => %{"bold" => true}},
        %{"insert" => "\n", "attributes" => %{"list" => "ordered"}},
        %{"insert" => "Serverless functions"},
        %{"insert" => "\n", "attributes" => %{"indent" => 1, "list" => "bullet"}},
        %{"insert" => "Edge computing"},
        %{"insert" => "\n", "attributes" => %{"indent" => 1, "list" => "bullet"}},
        %{"insert" => "GraphQL APIs"},
        %{"insert" => "\n", "attributes" => %{"indent" => 1, "list" => "bullet"}},
        %{"insert" => "Code Examples"},
        %{"insert" => "\n", "attributes" => %{"header" => 2}},
        %{"insert" => "\n"},
        %{"insert" => "Here's how you might implement a modern React hook:"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{
          "insert" =>
            "import { useState, useEffect } from 'react';\n\nfunction useCounter(initialValue = 0) {\n  const [count, setCount] = useState(initialValue);\n\n  useEffect(() => {\n    document.title = `Count: ${count}`;\n  }, [count]);\n\n  return [count, setCount];\n}\n"
        },
        %{"insert" => "\n", "attributes" => %{"code-block" => true, "code-block-lang" => "jsx"}},
        %{"insert" => "Mathematical Concepts"},
        %{"insert" => "\n", "attributes" => %{"header" => 3}},
        %{"insert" => "\n"},
        %{"insert" => "The time complexity can be expressed as O(n²), where "},
        %{"insert" => "n", "attributes" => %{"italic" => true}},
        %{"insert" => " represents the input size."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Images and Links"},
        %{"insert" => "\n", "attributes" => %{"header" => 2}},
        %{"insert" => "\n"},
        %{"insert" => %{"alt" => "Development Workflow", "image" => "https://example.com/dev-image.png"}},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "For more information, check out "},
        %{"insert" => "this comprehensive guide", "attributes" => %{"link" => "https://example.com/guide"}},
        %{"insert" => " on modern web development practices."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "***\n"},
        %{"insert" => "\n"},
        %{"insert" => "What do you think about these trends? Share your thoughts in the comments below.", "attributes" => %{"italic" => true}},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "converts technical documentation with tables and alerts" do
      input = """
      # API Reference

      ## Authentication

      > [!WARNING]
      > All API requests must include a valid API key.

      ### Endpoints

      | Method | Endpoint | Description |
      |--------|----------|-------------|
      | GET    | `/users` | List all users |
      | POST   | `/users` | Create new user |
      | DELETE | `/users/{id}` | Delete user |

      ## Error Codes

      The API returns standard HTTP status codes:

      - `200` - Success
      - `400` - Bad Request
      - `401` - Unauthorized
      - `500` - Internal Server Error

      ### Example Response

      ```json
      {
        "error": {
          "code": 400,
          "message": "Invalid request parameters"
        }
      }
      ```

      > [!NOTE]
      > Error messages are always returned in JSON format.

      ## Rate Limiting

      Requests are limited to **1000 per hour** per API key.
      """

      {:ok, result} = parse_with_extensions(input)

      expected = [
        %{"insert" => "API Reference"},
        %{"insert" => "\n", "attributes" => %{"header" => 1}},
        %{"insert" => "Authentication"},
        %{"insert" => "\n", "attributes" => %{"header" => 2}},
        %{"insert" => "[!WARNING]"},
        %{"insert" => " "},
        %{"insert" => "All API requests must include a valid API key."},
        %{"attributes" => %{"blockquote" => true}, "insert" => "\n"},
        %{"insert" => "Endpoints"},
        %{"attributes" => %{"header" => 3}, "insert" => "\n"},
        %{"insert" => "Method"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-1"}}, "insert" => "\n"},
        %{"insert" => "Endpoint"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-1"}}, "insert" => "\n"},
        %{"insert" => "Description"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-1"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-1"}, "insert" => "\n"},
        %{"insert" => "GET"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-2"}}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "/users"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-2"}}, "insert" => "\n"},
        %{"insert" => "List all users"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-2"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-2"}, "insert" => "\n"},
        %{"insert" => "POST"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-3"}}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "/users"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-3"}}, "insert" => "\n"},
        %{"insert" => "Create new user"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-3"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-3"}, "insert" => "\n"},
        %{"insert" => "DELETE"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-4"}}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "/users/{id}"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-4"}}, "insert" => "\n"},
        %{"insert" => "Delete user"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-4"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-4"}, "insert" => "\n"},
        %{"attributes" => %{"table" => true}, "insert" => "\n"},
        %{"insert" => "Error Codes"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "The API returns standard HTTP status codes:"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "200"},
        %{"insert" => " - Success"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "400"},
        %{"insert" => " - Bad Request"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "401"},
        %{"insert" => " - Unauthorized"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "500"},
        %{"insert" => " - Internal Server Error"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Example Response"},
        %{"attributes" => %{"header" => 3}, "insert" => "\n"},
        %{"insert" => "{\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"Invalid request parameters\"\n  }\n}\n"},
        %{"attributes" => %{"code-block" => true, "code-block-lang" => "json"}, "insert" => "\n"},
        %{"insert" => "[!NOTE]"},
        %{"insert" => " "},
        %{"insert" => "Error messages are always returned in JSON format."},
        %{"attributes" => %{"blockquote" => true}, "insert" => "\n"},
        %{"insert" => "Rate Limiting"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Requests are limited to "},
        %{"attributes" => %{"bold" => true}, "insert" => "1000 per hour"},
        %{"insert" => " per API key."},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "converts mixed content with all node types" do
      input = """
      # Complete Demo

      This document showcases **all** *major* ~~features~~ <u>available</u> in MDEx.

      ## Text Formatting

      - **Bold text**
      - *Italic text*
      - ~~Strikethrough~~
      - ++Underlined++
      - `inline code`
      - Regular text with H~2~O and E=mc^2^

      ## Links and Images

      Visit [our website](https://example.com) for more info.

      ![Sample Image](https://example.com/image.jpg "A sample image")

      ## Code Blocks

      ```elixir
      defmodule Example do
        def hello(name) do
          "Hello, \#{name}!"
        end
      end
      ```

      ## Lists

      ### Unordered
      - Item 1
      - Item 2
        - Nested item
        - Another nested

      ### Ordered
      1. First step
      2. Second step
      3. Final step

      ### Task List
      - [x] Completed task
      - [ ] Pending task
      - [x] Another done task

      ## Block Elements

      > This is a blockquote with some **bold** text inside.
      >
      > It can span multiple paragraphs.

      ---

      ## Tables

      | Feature | Status | Priority |
      |---------|---------|----------|
      | Delta Support | ✅ Complete | High |
      | Custom Converters | ✅ Complete | Medium |
      | Performance | 🔄 In Progress | Low |

      ## Math and Special Content

      Inline math: $x^2 + y^2 = z^2$

      Display math:
      $$
      \\\\sum_{i=1}^{n} i = \\\\frac{n(n+1)}{2}
      $$

      ## HTML Content

      <div class="custom">
        Custom HTML content
      </div>

      Some <span style="color: red">inline HTML</span> too.

      ## Front Matter

      ```yaml
      ---
      title: "Test Document"
      author: "MDEx"
      date: 2025-01-15
      ---
      ```

      That's all folks! 🎉
      """

      {:ok, result} = parse_with_extensions(input)

      expected = [
        %{"insert" => "Complete Demo"},
        %{"attributes" => %{"header" => 1}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "This document showcases "},
        %{"attributes" => %{"bold" => true}, "insert" => "all"},
        %{"insert" => " "},
        %{"attributes" => %{"italic" => true}, "insert" => "major"},
        %{"insert" => " "},
        %{
          "attributes" => %{"strike" => true},
          "insert" => "features"
        },
        %{"insert" => " "},
        %{"attributes" => %{"html" => "inline"}, "insert" => "<u>"},
        %{"insert" => "available"},
        %{"attributes" => %{"html" => "inline"}, "insert" => "</u>"},
        %{"insert" => " in MDEx."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Text Formatting"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"attributes" => %{"bold" => true}, "insert" => "Bold text"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"attributes" => %{"italic" => true}, "insert" => "Italic text"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"attributes" => %{"strike" => true}, "insert" => "Strikethrough"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "++Underlined++"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"attributes" => %{"code" => true}, "insert" => "inline code"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Regular text with H"},
        %{"attributes" => %{"subscript" => true}, "insert" => "2"},
        %{"insert" => "O and E=mc"},
        %{"attributes" => %{"superscript" => true}, "insert" => "2"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Links and Images"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Visit "},
        %{"attributes" => %{"link" => "https://example.com"}, "insert" => "our website"},
        %{"insert" => " for more info."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => %{"alt" => "A sample image", "image" => "https://example.com/image.jpg"}},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Code Blocks"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "defmodule Example do\n  def hello(name) do\n    \"Hello, \#{name}!\"\n  end\nend\n"},
        %{"attributes" => %{"code-block" => true, "code-block-lang" => "elixir"}, "insert" => "\n"},
        %{"insert" => "Lists"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "Unordered"},
        %{"attributes" => %{"header" => 3}, "insert" => "\n"},
        %{"insert" => "Item 1"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Item 2"},
        %{"attributes" => %{"list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Nested item"},
        %{"attributes" => %{"indent" => 1, "list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Another nested"},
        %{"attributes" => %{"indent" => 1, "list" => "bullet"}, "insert" => "\n"},
        %{"insert" => "Ordered"},
        %{"attributes" => %{"header" => 3}, "insert" => "\n"},
        %{"insert" => "First step"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Second step"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Final step"},
        %{"attributes" => %{"list" => "ordered"}, "insert" => "\n"},
        %{"insert" => "Task List"},
        %{"attributes" => %{"header" => 3}, "insert" => "\n"},
        %{"insert" => "Completed task"},
        %{"attributes" => %{"list" => "bullet", "task" => true}, "insert" => "\n"},
        %{"insert" => "Pending task"},
        %{"attributes" => %{"list" => "bullet", "task" => false}, "insert" => "\n"},
        %{"insert" => "Another done task"},
        %{"attributes" => %{"list" => "bullet", "task" => true}, "insert" => "\n"},
        %{"insert" => "Block Elements"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "This is a blockquote with some "},
        %{"attributes" => %{"bold" => true}, "insert" => "bold"},
        %{"insert" => " text inside."},
        %{"attributes" => %{"blockquote" => true}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => ">"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "It can span multiple paragraphs."},
        %{"attributes" => %{"blockquote" => true}, "insert" => "\n"},
        %{"insert" => "***\n"},
        %{"insert" => "Tables"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "Feature"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-1"}}, "insert" => "\n"},
        %{"insert" => "Status"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-1"}}, "insert" => "\n"},
        %{"insert" => "Priority"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-1"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-1"}, "insert" => "\n"},
        %{"insert" => "Delta Support"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-2"}}, "insert" => "\n"},
        %{"insert" => "✅ Complete"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-2"}}, "insert" => "\n"},
        %{"insert" => "High"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-2"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-2"}, "insert" => "\n"},
        %{"insert" => "Custom Converters"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-3"}}, "insert" => "\n"},
        %{"insert" => "✅ Complete"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-3"}}, "insert" => "\n"},
        %{"insert" => "Medium"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-3"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-3"}, "insert" => "\n"},
        %{"insert" => "Performance"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-1", "row" => "row-4"}}, "insert" => "\n"},
        %{"insert" => "🔄 In Progress"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-2", "row" => "row-4"}}, "insert" => "\n"},
        %{"insert" => "Low"},
        %{"attributes" => %{"table-cell-line" => %{"cell" => "cell-3", "row" => "row-4"}}, "insert" => "\n"},
        %{"attributes" => %{"table-row" => "row-4"}, "insert" => "\n"},
        %{"attributes" => %{"table" => true}, "insert" => "\n"},
        %{"insert" => "Math and Special Content"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Inline math: "},
        %{"attributes" => %{"math" => "inline"}, "insert" => "x^2 + y^2 = z^2"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Display math:"},
        %{"insert" => " "},
        %{"attributes" => %{"math" => "display"}, "insert" => "\n\\\\sum_{i=1}^{n} i = \\\\frac{n(n+1)}{2}\n"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "HTML Content"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "<div class=\"custom\">\n  Custom HTML content\n</div>\n"},
        %{"attributes" => %{"html" => "block"}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Some "},
        %{"attributes" => %{"html" => "inline"}, "insert" => "<span style=\"color: red\">"},
        %{"insert" => "inline HTML"},
        %{"attributes" => %{"html" => "inline"}, "insert" => "</span>"},
        %{"insert" => " too."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Front Matter"},
        %{"attributes" => %{"header" => 2}, "insert" => "\n"},
        %{"insert" => "---\ntitle: \"Test Document\"\nauthor: \"MDEx\"\ndate: 2025-01-15\n---\n"},
        %{"attributes" => %{"code-block" => true, "code-block-lang" => "yaml"}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "That's all folks! 🎉"},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "handles empty and minimal documents" do
      # Empty document
      input = ""
      {:ok, []} = parse_with_extensions(input)

      # Just whitespace
      input = "   \n  \n  "
      {:ok, []} = parse_with_extensions(input)

      # Single word
      input = "Hello"
      {:ok, result} = parse_with_extensions(input)

      assert result == [
               %{"insert" => "Hello"},
               %{"insert" => "\n"}
             ]

      # Single header
      input = "# Title"
      {:ok, result} = parse_with_extensions(input)

      assert result == [
               %{"insert" => "Title"},
               %{"attributes" => %{"header" => 1}, "insert" => "\n"}
             ]
    end

    test "handles documents with only exotic nodes" do
      input = """
      H~2~O and E=mc^2^

      $\\\\sum x_i$ inline math

      $$
      x^2 + y^2 = z^2
      $$

      - [x] Task 1
      - [ ] Task 2

      [[WikiLink]] reference

      ||spoiler text|| content

      > [!NOTE]
      > This is an alert
      """

      {:ok, result} = parse_with_extensions(input)

      expected = [
        %{"insert" => "H"},
        %{"attributes" => %{"subscript" => true}, "insert" => "2"},
        %{"insert" => "O and E=mc"},
        %{"attributes" => %{"superscript" => true}, "insert" => "2"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"attributes" => %{"math" => "inline"}, "insert" => "\\\\sum x_i"},
        %{"insert" => " inline math"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"attributes" => %{"math" => "display"}, "insert" => "\nx^2 + y^2 = z^2\n"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Task 1"},
        %{"attributes" => %{"list" => "bullet", "task" => true}, "insert" => "\n"},
        %{"insert" => "Task 2"},
        %{"attributes" => %{"list" => "bullet", "task" => false}, "insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "[[WikiLink]] reference"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"attributes" => %{"spoiler" => true}, "insert" => "spoiler text"},
        %{"insert" => " content"},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "[!NOTE]"},
        %{"insert" => " "},
        %{"insert" => "This is an alert"},
        %{"attributes" => %{"blockquote" => true}, "insert" => "\n"}
      ]

      assert result == expected
    end
  end

  describe "public API input types" do
    test "converts Document struct directly" do
      input = %MDEx.Document{
        nodes: [
          %MDEx.Paragraph{
            nodes: [%MDEx.Text{literal: "Direct document conversion"}]
          }
        ]
      }

      {:ok, result} = MDEx.to_delta(input)

      expected = [
        %{"insert" => "Direct document conversion"},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "converts Pipe struct" do
      input = MDEx.new(document: "*italic*")

      {:ok, result} = MDEx.to_delta(input)

      expected = [
        %{"insert" => "italic", "attributes" => %{"italic" => true}},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "converts single node fragment" do
      input = %MDEx.Text{literal: "Fragment text"}

      {:ok, result} = MDEx.to_delta(input)

      expected = [
        %{"insert" => "Fragment text"}
      ]

      assert result == expected
    end

    test "converts list of nodes fragment" do
      input = [
        %MDEx.Text{literal: "First "},
        %MDEx.Strong{nodes: [%MDEx.Text{literal: "bold"}]},
        %MDEx.Text{literal: " text"}
      ]

      {:ok, result} = MDEx.to_delta(input)

      expected = [
        %{"insert" => "First "},
        %{"insert" => "bold", "attributes" => %{"bold" => true}},
        %{"insert" => " text"}
      ]

      assert result == expected
    end

    test "to_delta! returns delta directly on success" do
      input = "**bold**"

      result = MDEx.to_delta!(input)

      expected = [
        %{"insert" => "bold", "attributes" => %{"bold" => true}},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "to_delta! raises on invalid input" do
      assert_raise MDEx.InvalidInputError, fn ->
        MDEx.to_delta!(%{invalid: "input"})
      end
    end

    test "accepts custom_converters option" do
      input = "Hello world"
      options = [custom_converters: %{}]

      {:ok, result} = MDEx.to_delta(input, options)

      expected = [
        %{"insert" => "Hello world"},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end

    test "paragraph spacing preserves blank lines" do
      input = """
      First paragraph.

      Second paragraph after blank line.

      Third paragraph.
      """

      {:ok, result} = parse_with_extensions(input)

      expected = [
        %{"insert" => "First paragraph."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Second paragraph after blank line."},
        %{"insert" => "\n"},
        %{"insert" => "\n"},
        %{"insert" => "Third paragraph."},
        %{"insert" => "\n"}
      ]

      assert result == expected
    end
  end
end
