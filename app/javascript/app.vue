<template>
  <div id="app">
    <p>{{ message }}</p>
    <p v-text="message"></p>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Unko Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
