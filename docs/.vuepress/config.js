const domain = '3musketeers.io'
const url = `https://${domain}`
const desc = 'Test, build, and deploy your apps from anywhere, the same way!'
const logoRel = '/logo.png'
const title = '3 Musketeers'

module.exports = {
  title: '3 Musketeers',
  description: desc,
  head: [
    ['link', { rel: 'icon', href: logoRel }],
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
    '@vuepress/back-to-top',
    '@vuepress/search',
    {
      searchMaxSuggestions: 10,
    },
  ],
  themeConfig: {
    lastUpdated: true,
    repo: 'flemay/3musketeers',
    repoLabel: 'GitHub',
    docsRepo: 'flemay/3musketeers',
    docsDir: 'docs',
    docsBranch: 'master',
    editLinks: true,
    editLinkText: 'Edit this page on GitHub',
    nav: [
      { text: 'About', link: '/about/' },
      { text: 'Docs', link: '/docs/' },
      { text: 'Examples', link: '/examples/' },
    ],
    sidebar: getSidebar(),
  },
}

function getSidebar() {
  return [
    {
      title: 'About',
      collapsable: false,
      children: ['/about/', '/about/contributing'],
    },
    {
      title: 'Docs',
      collapsable: false,
      children: [
        '/docs/',
        '/docs/patterns',
        '/docs/make',
        '/docs/docker',
        '/docs/compose',
        '/docs/environment-variables',
        '/docs/other-tips',
      ],
    },
    {
      title: 'Examples',
      collapsable: false,
      path: '/examples/',
      children: [],
    },
  ]
}
