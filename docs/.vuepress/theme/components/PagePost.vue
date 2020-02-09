<template>
  <main class="page">
    <article class="theme-default-content">
      <h1>{{ this.$page.frontmatter.title }}</h1>
      <Content />
      <br>
      <footer>
        <nav><span>←<a href="/blog/">Back</a></span></nav>
      </footer>
    </article>
  </main>
</template>