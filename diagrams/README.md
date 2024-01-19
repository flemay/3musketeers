# Diagrams

This is self-content code to generate [Mermaid][linkMermaid] diagrams used by the website.

## Prerequisites

- [Docker][linkDocker]
- [Compose][linkCompose]
- [Make][linkMake]

## Usage

```bash
# Prepare environment
make deps
# Generate the diagrams and copy them where needed by the website
make generate
# Go inside the mermaid container
make shell
# Clean up
make prune
```

## References

- [Mermaid][linkMermaid]
- [mermaid-cli][linkMermaidCLI]
- [Docker][linkDocker]
- [Compose][linkCompose]
- [Make][linkMake]


[linkMermaid]: https://mermaid.js.org
[linkMermaidCLI]: https://github.com/mermaid-js/mermaid-cli
[linkDocker]: https://www.docker.com
[linkCompose]: https://docs.docker.com/compose/
[linkMake]: https://www.gnu.org/software/make/
