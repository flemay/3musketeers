module.exports = {
  title: '3 Musketeers',
  description: 'Test, build, and deploy your apps from anywhere, the same way.',
  head: [
    ['link', { rel: 'icon', href: '/logo.png' }]
  ],
  plugins: [
    '@vuepress/back-to-top',
    '@vuepress/search', {
      searchMaxSuggestions: 10,
    },
  ],
  themeConfig: {
    lastUpdated: 'Last Updated',
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
    sidebar: getSidebar()
  }
}

function getSidebar() {
  return [
    {
      title: 'About',
      collapsable: false,
      children: [
        '/about/',
        '/about/contributing'
      ]
    },
    {
      title: 'Docs',
      collapsable: false,
      path: '/docs/',
      children: [
        '/docs/get-started',
        '/docs/patterns',
        '/docs/make',
        '/docs/docker',
        '/docs/compose',
        '/docs/environment-variables',
        '/docs/other-tips',
      ]
    },
    {
      title: 'Examples',
      collapsable: false,
      path: '/examples/',
      children: [
      ]
    },
  ]
}
