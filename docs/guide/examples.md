# Examples

Here are some examples on how to apply the 3 Musketeers for different kinds of applications.

- [Hello, World!][linkHelloWorld] is the simplest example showing the 3 Musketeers in action.
- [3musketeers.io][link3Musketeers] uses 3 Musketeers to build VuePress website and deploy to Netlify with GitHub Actions.
- [envvars][linkEnvvars] is a small Go application that uses GitHub Actions to build, test, and create a Docker image.
- [flemay/musketeers][linkFlemayMusketeers] is a docker image that is built, tested, and deployed with GitHub Actions to Docker Hub.
- [flemay/cookiecutter][linkFlemayCookiecutter] is a docker image that is built, tested, and deployed to Docker Hub with GitLab CI/CD. The pipeline uses Docker in Docker (DinD) with the image `flemay/musketeers`.
- [Echo][linkEcho] is a Cookiecutter template for a basic example that echoes the value of an environment variable.

[linkHelloWorld]: get-started
[link3Musketeers]: https://github.com/flemay/3musketeers
[linkEnvvars]: https://github.com/flemay/envvars
[linkFlemayCookiecutter]: https://gitlab.com/flemay/docker-cookiecutter
[linkFlemayMusketeers]: https://github.com/flemay/docker-images
[linkEcho]: https://github.com/3musketeersio/cookiecutter-musketeers-echo
