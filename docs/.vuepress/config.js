module.exports = {
  title: '3 Musketeers',
  description: 'Test, build, and deploy your apps from anywhere, the same way.',
  plugins: ['@vuepress/back-to-top'],
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
      { text: 'Examples', link: '/examples' },
    ],
    sidebar: getSidebar()
  }
}

function getSidebar() {
  return [
    {
      title: 'About',
      collapsable: false,
      sidebarDepth: 2,
      children: [
        '/about/',
        '/about/contributing'
      ]
    },
    {
      title: 'Docs',
      collapsable: false,
      path: '/docs/',
      sidebarDepth: 2,
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
      path: 'examples',
      children: [
      ]
    },
  ]
}
