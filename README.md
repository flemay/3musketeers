<p align="center"><img src="assets/img/logo.jpg" width="300"></p>

[![Build Status](https://travis-ci.org/flemay/3musketeers.svg?branch=master)](https://travis-ci.org/flemay/3musketeers)
[![License](https://img.shields.io/dub/l/vibe-d.svg)](LICENSE)

# 3 Musketeers

Test, build, and deploy your apps from anywhere, the same way.

The 3 Musketeers is a pattern for developing software in a repeatable and consistent manner. It leverages Make as an orchestration tool to test, build, run, and deploy applications using Docker and Docker Compose. The Make and Docker/Compose commands for each application are maintained as part of the application’s source code and are invoked in the same way whether run locally or on a CI/CD server.