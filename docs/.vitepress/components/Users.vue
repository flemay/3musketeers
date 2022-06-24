<template>
  <div class="users-container" v-if="data.users && data.users.length">
    <a class="user-container" v-for="user in data.users" v-bind:href="user.url">
      <div class="img-container">
        <img v-bind:src="user.image" v-bind:alt="user.name">
      </div>
      <span>{{ user.name }}</span>
    </a>
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
$user-container-height = 200px
$user-container-width = 200px
$img-container-height  = 150px
$img-container-width = 150px

.users-container
  display flex
  flex-wrap wrap
  align-items flex-start
  align-content space-around
  justify-content center
  margin-bottom 50px
  .user-container
    display flex
    flex-direction column
    justify-content flex-end
    align-items center
    height $user-container-height
    width $user-container-width
    .img-container
      display flex
      flex-direction column
      height $img-container-height
      justify-content center
      padding 5px
      img
        max-height $img-container-height
        max-width $img-container-height
</style>
