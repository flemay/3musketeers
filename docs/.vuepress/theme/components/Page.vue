// Post template cannot replace the Page component of the parent layout, so this template overrides it. https://vuepress.vuejs.org/theme/inheritance.html#override-components
// If the frontmatter layout of the page is `Post` (plugin-blog generates it), it renders PagePost, otherwise, ParentPage. https://vuepress.vuejs.org/theme/inheritance.html#access-parent-theme
// Always override the minimum and reuse the parent files as much as possible to reduce the risk of breaking change when upgrading VuePress.
<template>
  <PagePost v-if="isPost"/>
  <ParentPage
    v-else
    :sidebar-items="sidebarItems"
  />
</template>

<script>
import ParentPage from '@parent-theme/components/Page.vue'
import { resolveSidebarItems } from '@parent-theme/util'
import PagePost from '@theme/components/PagePost.vue'

export default {
  components: {
    ParentPage,
    PagePost,
  },

  computed: {
    isPost() {
      return this.$page.frontmatter.layout === 'Post'
    },
    // Copied from @parent-theme/layouts/Layout.vue
    sidebarItems () {
      return resolveSidebarItems(
        this.$page,
        this.$page.regularPath,
        this.$site,
        this.$localePath
      )
    },
  },
}
</script>