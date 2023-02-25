# Tools

## Docker

Docker is the most important musketeer of the three. Many tasks such as testing, building, running, and deploying can all be done inside a lightweight Docker container — which can be run on different operating system. The portability of Docker ensures you can execute the same tasks, the same way, on different environment like MacOS, Linux, Windows, and CI/CD tools.

## Make

Make is a cross-platform build tool to test and build software and it is used as an interface between the CI/CD server and the application code. A single Makefile per application defines and encapsulates all the steps for testing, building, and deploying that application. Of course other tools like rake or ant can be used to achieve the same goal, but having Makefile pre-installed in many OS distributions makes it a convenient choice.

## Compose

Docker Compose, or simply Compose, manages Docker containers in a very neat way. It allows multiple Docker commands to be written as a single one, which allows our Makefile to be a lot cleaner and easier to maintain. Testing also often involves container dependencies, such as a database, which is an area where Compose really shines. No need to create the database container and link it to your application code container manually — Compose takes care of this for you.

## Alternatives

The 3 Musketeers pattern helps software development by being repeatable and consistent across different environments. Running tasks such as testing should not be any different locally than on a CI/CD tool. The combination of Make, Docker, and Compose achieve that.

Other tools can definitely be used to meet the same goal depending on your own context. You or your organisation may not need to support Windows for instance, and a tool like [zeus&#8599;][linkZeus] can replace Make. You may also just want to rely on shell scripts and Docker, or use only Make and Docker. See [patterns][linkPatterns] for other suggestions.


[linkPatterns]: patterns
[linkZeus]: https://github.com/dreadl0ck/zeus
