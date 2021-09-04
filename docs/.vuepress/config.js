const domain = '3musketeers.io'
const url = `https://${domain}`
const desc = 'Test, build, and deploy your apps from anywhere, the same way!'
const logoRel = '/img/logo.png'
const title = '3 Musketeers'

module.exports = {
  title: '3 Musketeers',
  description: desc,
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
  plugins: [
    [
      '@vuepress/plugin-search',
      {
        maxSuggestions: 10,
        locales: {
          '/': {
            placeholder: 'Search',
          },
        },
      },
    ],
  ],
  themeConfig: {
    repo: 'https://github.com/flemay/3musketeers',
    repoLabel: 'GitHub',
    docsRepo: 'flemay/3musketeers',
    contributors: false,
    docsDir: 'docs',
    navbar: [
      { text: 'About', link: '/about/' },
      { text: 'Docs', link: '/docs/' },
      { text: 'Examples', link: '/examples/' },
      { text: 'Blog', link: '/blog/' },
    ],
    sidebar: {
      '/about/': getAboutSidebar(),
      '/docs/': getDocsSidebar(),
    },
  },
}

function getAboutSidebar() {
  return [
    {
      text: 'About',
      collapsable: false,
      children: ['/about/', '/about/tools', '/about/contributing'],
    }
  ]
}

function getDocsSidebar() {
  return [
    {
      text: 'Docs',
      collapsable: false,
      children: [
        '/docs/',
        '/docs/patterns',
        '/docs/make',
        '/docs/docker',
        '/docs/compose',
        '/docs/project-dependencies',
        '/docs/environment-variables',
        '/docs/other-tips',
      ]
    }
  ]
}
