# Project dependencies

Dependencies play a major role when comes time to test, build, and deploy a project. A project can have many dependencies such as programing languages, third party packages, databases, etc. This section covers some approaches to handle them with the 3 Musketeers.

::: tip
It is not uncommon for a project to use a mix of the ways described in this section. For instance, a project may have a local Docker images for some dependencies and rely on an official database image.
:::

## Official Docker images

This way relies on official Docker images to deal with dependencies. For instance, a NodeJS project may use the official NodeJS Docker image to install the node modules, run and test the application. Usually third party packages will be shared with the host and containers. The main benefit of this approach is that there is no need to maintain any Docker image.

:::tip
The [3 Musketeers website](https://github.com/flemay/3musketeers) uses this approach.
:::

## Custom Docker images

Relying on official images may not be always possible. For instance, you may have specific dependencies and custom code to deploy softwares in the cloud, that other projects rely on when deploying. In this case, you would be responsible to build, test and deploy your custom image to a Docker registry (potentially done with a pipeline). This is very useful when many projects depends on but it requires you to maintain it.

## Local Docker images

If a project has specific dependency requirements, then creating (and maintaining) a custom Docker image may be overkill. Instead, you could have a Dockerfile that encapsulates the dependencies which would require you to build. This also works well if the project uses a CI tool where there is only one stage (such as GitHub Actions) because there is no need to cache and share dependencies. The image gets built at the beginning of the pipeline and used util the end.

:::tip
[fredericlemay.com](https://github.com/flemay/fredericlemay-com) uses this approach to build and deploy a Hugo website to Netlify.
:::

## Share dependencies with host or not

All the approaches discussed above can share third party dependencies with the host...