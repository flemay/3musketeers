---
title: Alternatives
sidebar:
  order: 4
---

The 3 Musketeers pattern helps software development by being repeatable and
consistent across different environments. Running tasks such as testing should
not be any different locally than on a CI/CD tool. The combination of Make,
Docker, and Compose achieve that.

Other tools can definitely be used to meet the same goal depending on your own
context. You or your organisation may not need to support Windows for instance,
and a tool like [zeus][linkZeus] can replace Make. You may also just want to
rely on shell scripts and Docker, or use only Make and Docker. See
[patterns][linkPatterns] for other suggestions.

[linkPatterns]: /guides/patterns
[linkZeus]: https://github.com/dreadl0ck/zeus
