// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

const githubUrl = "https://github.com/flemay/3musketeers";

// https://astro.build/config
// https://starlight.astro.build/reference/configuration/
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
        "./src/styles/global.css",
      ],
      components: {
        Footer: "./src/components/ConditionalFooter.astro",
      },
      expressiveCode: {
        // https://expressive-code.com/reference/configuration/#tabwidth
        // There are many `make` code blocks which requires tabs. Setting `tabWidth` will preserve those tabs.
        tabWidth: 0,
      },
      head: [
        {
          tag: "link",
          attrs: {
            rel: "apple-touch-icon",
            sizes: "180x180",
            href: "/apple-touch-icon.png",
          },
        },
        {
          tag: "link",
          attrs: {
            rel: "icon",
            type: "image/png",
            sizes: "32x32",
            href: "/favicon_io/favicon-32x32.png",
          },
        },
        {
          tag: "link",
          attrs: {
            rel: "icon",
            type: "image/png",
            sizes: "16x16",
            href: "/favicon_io/favicon-16x6.png",
          },
        },
        {
          tag: "link",
          attrs: {
            rel: "manifest",
            href: "/favicon_io/site.webmanifest",
          },
        },
      ],
      favicon: "favicon_io/favicon.ico",
      social: [{
        icon: "github",
        label: "GitHub",
        href: githubUrl,
      }],
      editLink: {
        baseUrl: githubUrl,
      },
      lastUpdated: true,
      tableOfContents: {
        maxHeadingLevel: 5,
      },
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
          label: "Tools",
          autogenerate: { directory: "tools" },
        },
        {
          label: "Resources",
          autogenerate: { directory: "resources" },
        },
      ],
    }),
  ],
});
