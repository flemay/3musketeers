<template>
  <div>
    <div class="users-container">
      <div class="user-container" v-for="user in data.users">
        <div class="user-card">
          <img v-bind:src="user.image" v-bind:alt="user.name">
          <a v-bind:href="user.url">{{ user.name }}</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    data() {
      return this.$page.frontmatter;
    }
  }
}
</script>

<style lang="stylus">
.users-container
  display flex
  flex-wrap wrap
  align-items flex-start
  align-content space-around
  justify-content center
  margin-bottom 50px
  .user-container
    flex-direction column
    margin 25px
    max-width 150px
    .user-card
      text-align center
</style>
