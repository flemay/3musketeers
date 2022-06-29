const domain = '3musketeers.io'
const url = `https://${domain}`
const desc = 'Test, build, and deploy your apps from anywhere, the same way.'
const logoRel = '/img/logo.png'
const title = '3 Musketeers'
const github = 'https://github.com/flemay/3musketeers'

export default {
  title: title,
  description: desc,
  lastUpdated: true,

  head: [
    ['link', { rel: 'apple-touch-icon', sizes: '180x180', href: '/favicon/apple-touch-icon.png' }],
    ['link', { rel: 'icon', type: 'image/png', sizes: '32x32', href: '/favicon/favicon-32x32.png' }],
    ['link', { rel: 'icon', type: 'image/png', sizes: '16x16', href: '/favicon/favicon-16x16.png' }],
    ['link', { rel: 'manifest', href: '/favicon/site.webmanifest' }],
    ['link', { rel: 'mask-icon', href: '/favicon/safari-pinned-tab.svg', color: '#000000' }],
    ['link', { rel: 'shortcut icon', href: '/favicon/favicon.ico' }],
    ['meta', { name: 'msapplication-TileColor', content: '#000000' }],
    ['meta', { name: 'msapplication-config', content: '/favicon/browserconfig.xml' }],
    ['meta', { name: 'theme-color', content: '#000000' }],

    // facebook open graph tags
    ['meta', { property: 'og:url', content: url }],
    ['meta', { property: 'og:title', content: title }],
    ['meta', { property: 'og:description', content: desc }],
    ['meta', { property: 'og:site_name', content: domain }],
    ['meta', { property: 'og:image', content: logoRel }],

    //twitter card tags additive with the og: tags
    ['meta', { name: 'twitter:domain', value: domain }],
    ['meta', { name: 'twitter:title', value: title }],
    ['meta', { name: 'twitter:description', value: desc }],
    ['meta', { name: 'twitter:image', content: logoRel }],
    ['meta', { name: 'twitter:url', value: url }],
  ],

  themeConfig: {
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
        { text: 'Other tips', link: '/guide/other-tips' },
        { text: 'Examples', link: '/guide/examples' },
      ]
    }
  ]
}
