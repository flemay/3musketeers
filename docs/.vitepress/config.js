const domain = '3musketeers.io'
const url = `https://${domain}`
const desc = 'Test, build, and deploy your apps from anywhere, the same way.'
const socialImage = '/img/social-image.jpg'
const title = '3 Musketeers'
const github = 'https://github.com/flemay/3musketeers'

export default {
  title: title,
  description: desc,
  lastUpdated: true,

  head: [
    ['link', { rel: 'apple-touch-icon', sizes: '180x180', href: '/favicon_io/apple-touch-icon.png' }],
    ['link', { rel: 'icon', type: 'image/png', sizes: '32x32', href: '/favicon_io/favicon-32x32.png' }],
    ['link', { rel: 'icon', type: 'image/png', sizes: '16x16', href: '/favicon_io/favicon-16x16.png' }],
    ['link', { rel: 'manifest', href: 'favicon_io/site.webmanifest' }],

    // Open graph protocol
    ['meta', { property: 'og:url', content: url }],
    ['meta', { property: 'og:title', content: title }],
    ['meta', { property: 'og:description', content: desc }],
    ['meta', { property: 'og:image', content: socialImage }],
    ['meta', { property: 'og:site_name', content: domain }],

    //twitter card tags additive with the og: tags
    ['meta', { name: 'twitter:domain', value: domain }],
    ['meta', { name: 'twitter:url', value: url }],
  ],

  themeConfig: {
    logo: '/img/hero-v2.svg',
    siteTitle: title,
    editLink: {
      pattern: `${github}/edit/main/docs/:path`,
      text: 'Edit this page on GitHub'
    },
    nav: [
      { text: 'Guide', link: '/guide/', activeMatch: '/guide/' },
      { text: 'Blog', link: '/blog/', activeMatch: '/blog/' },
    ],
    sidebar: {
      '/guide/': getGuideSidebar()
    },
    socialLinks: [
      { icon: 'github', link: github },
    ],
    footer: {
      message: 'MIT Licensed',
      copyright: 'Copyright © 2018 Frederic Lemay'
    }
  }
}

function getGuideSidebar() {
  return [
    {
      text: 'About',
      collapsible: true,
      items: [
        { text: 'What is 3 Musketeers?', link: '/guide/' },
        { text: 'Tools', link: '/guide/tools' },
        { text: 'Contributing', link: '/guide/contributing' }
      ]
    },
    {
      text: 'Guide',
      collapsible: true,
      items: [
        { text: 'Get Started', link: '/guide/get-started' },
        { text: 'Patterns', link: '/guide/patterns' },
        { text: 'Make', link: '/guide/make' },
        { text: 'Docker', link: '/guide/docker' },
        { text: 'Compose', link: '/guide/compose' },
        { text: 'Project dependencies', link: '/guide/project-dependencies' },
        { text: 'Environment variables', link: '/guide/environment-variables' },
        { text: 'Examples', link: '/guide/examples' },
        { text: 'Misc', link: '/guide/misc' },
      ]
    }
  ]
}
