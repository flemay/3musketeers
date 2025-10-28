// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

const githubUrl = "https://github.com/flemay/3musketeers";

// https://astro.build/config
export default defineConfig({
  integrations: [
    starlight({
      title: "3 Musketeers",
      description:
        "Test, build, and deploy your apps from anywhere, the same way!",
      logo: {
        src: "./src/assets/logo/hero-v2.svg",
      },
      customCss: [
        "./src/styles/custom.css",
      ],
      components: {
        Footer: "./src/components/Footer.astro",
      },
      favicon: "favicon.ico",
      social: [{
        icon: "github",
        label: "GitHub",
        href: githubUrl,
      }],
      editLink: {
        baseUrl: githubUrl,
      },
      lastUpdated: true,
      sidebar: [
        {
          label: "About",
          autogenerate: { directory: "about" },
        },
        {
          label: "Guides",
          autogenerate: { directory: "guides" },
        },
        {
          label: "Resources",
          autogenerate: { directory: "resources" },
        },
      ],
    }),
  ],
});
