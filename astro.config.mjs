// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
  integrations: [
    starlight({
      title: "3 Musketeers",
      favicon: "favicon.ico",
      social: [{
        icon: "github",
        label: "GitHub",
        href: "https://github.com/flemay/3musketeers",
      }],
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
