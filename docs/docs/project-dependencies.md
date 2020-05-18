# Project dependencies

Dependencies play a major role when comes time to test, build, and deploy a project. A project can have many dependencies such as programing languages, third party packages, databases, etc. This section covers some approaches to handle them with the 3 Musketeers.

::: tip
It is not uncommon for a project to combine the approaches. For instance, a project may have a local Docker images for some dependencies and use an official database image.
:::

## Official Docker images

This way relies on official Docker images to deal with dependencies. For instance, a NodeJS project may use the official NodeJS Docker image to install the node modules, run and test the application. Usually third party packages will be shared with the host and containers. The main benefit of this approach is that there is no need to maintain any Docker image.

:::tip
The [3 Musketeers website](https://github.com/flemay/3musketeers) is built with this approach.
:::

## Custom Docker images

Relying on official images may not be always possible. For instance, you may have specific dependencies and custom code to deploy softwares in the cloud, that other projects rely on when deploying. In this case, you would be responsible to build, test and deploy your custom image to a Docker registry. This is very useful when many projects depends on but it requires you to maintain it.

## Local custom Docker images

If a project has specific dependency requirements, then creating (and maintaining) a custom Docker image may be overkill. Instead, the project could have a Dockerfile that encapsulates the dependencies which would require the image to be built locally before use. This also works well if the project uses a CI tool where there is only one stage (such as GitHub Actions) because there is no need to share dependencies between stages.

:::tip
This approach is used to build [fredericlemay.com](https://github.com/flemay/fredericlemay-com), a Hugo website, and deploy to Netlify.
:::

## Share dependencies with host or not

All the approaches discussed above can share third party dependencies with the host, usually by mounting a host directory to a Docker container and letting the container install the dependencies. An example would be like this website where a NodeJS container installs the packages and the `node_modules` folder is shared with the host. This is useful when developing as your IDE of choice can do autocomplete if the host supports the dependencies. Those dependencies can also be compressed and passed along the pipeline stages which is usually faster that re-installing them.

Of course, installing the dependencies when building a Docker image is another viable option especially if you do not need autocompletion, or your pipeline is basically one stage.

## One or many Docker images

Usually, using official images, which tend to follow the single responsibility principle, is preferable as those images' maintenance is already taken care of. However, as stated before, they do not solve all problems and using a single custom Docker image may make the project development simpler in some cases. Of course, a project can rely on both official and custom images.