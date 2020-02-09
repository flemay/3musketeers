<template>
  <main class="page">
    <div class="theme-default-content">
      <h1>Blog</h1>
      <br>
      <div v-for="page in pages">
        <h3>{{ page.frontmatter.title }}</h3>
        <p>{{ page.frontmatter.summary }}</p>
        <a :href="page.path">Read more</a>
      </div>
    </div>
  </main>
</template>

<script>
export default {
  computed: {
    pages() {
      return this.$pagination.pages
    },
  }
}
</script>