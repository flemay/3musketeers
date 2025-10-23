// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

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
      favicon: "favicon.ico",
      social: [{
        icon: "github",
        label: "GitHub",
        href: "https://github.com/flemay/3musketeers",
      }],
      editLink: {
        // baseUrl: "https://github.com/flemay/3musketeers/edit/main/",
        baseUrl: "https://github.com/flemay/3musketeers",
      },
      lastUpdated: true,
      sidebar: [
        {
          label: "About",
          items: [
            { slug: "about" },
          ],
        },
        {
          label: "Guides",
          items: [
            { slug: "guides/getting-started" },
          ],
        },
      ],
    }),
  ],
});
