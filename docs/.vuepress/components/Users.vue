<template>
  <div>
    <div class="users-container">
      <div class="user-container" v-for="user in data.users">
        <div class="img-container">
          <img v-bind:src="user.image" v-bind:alt="user.name">
        </div>
        <a v-bind:href="user.url">{{ user.name }}</a>
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
$user-container-height = 160px
$user-container-width = 150px
$img-container-height = 130px

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
    margin 25px
    justify-content flex-end
    align-items center
    height $user-container-height
    width $user-container-width
    .img-container
      display flex
      flex-direction column
      height $img-container-height
      justify-content center
      img
        max-height $img-container-height
        max-width $user-container-width
</style>
