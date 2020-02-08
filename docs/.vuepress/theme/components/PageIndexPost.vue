<template>
  <main class="page">
    <div class="theme-default-content">
      <div v-for="page in pages" :key="page.key">
        <div>
          {{ page.title }}
        </div>
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