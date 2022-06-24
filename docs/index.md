---
layout: home
hero:
  heroImage: /img/hero.jpg
  name: 3 Musketeers
  text: Test, build, and deploy your apps from anywhere, the same way.
  actions:
    - text: Get Started
      link: /docs/
      theme: brand
    - text: About
      link: /about/
      theme: alt
features:
  - title: Consistency
    details: 'Run the same commands no matter where you are: Linux, MacOS, Windows, CI/CD tools that supports Docker like GitHub Actions, Travis CI, CircleCI, and GitLab CI.'
  - title: Control
    details: Take control of languages, versions, and tools you need, and version source control your pipelines with your preferred VCS like GitHub and GitLab.
  - title: Confidence
    details: Test your code and pipelines locally before your CI/CD tool runs it. Feel confident that if it works locally, it will work in your CI/CD server.
---

### Hello, World!

::: info REQUIREMENTS
This example requires Make, Docker, and Compose.
:::

```yaml
# docker-compose.yml
version: '3'
services:
  alpine:
    image: alpine
```

```makefile
# Makefile

# echo calls Compose to run the command "echo 'Hello, World!'" in a Docker container
echo:
	docker-compose run --rm alpine echo 'Hello, World!'
```

```bash
# echo 'Hello, World!' with the following command
$ make echo
```
