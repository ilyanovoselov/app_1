<template>
  <div id="app" v-if="seen">
    <p>{{ message }}</p>

    <div v-for="img in images">
        <img :src="img.src" :alt="img.name">
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Vue Memo Game!",
      seen: true,
      images: [
          {name: 'eltex_1', id: 1, src: 'images/memo/1_eltex/ME5000.png'},
      ]
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

img{
  width:100px;
  margin:6px;
  box-shadow: 0 0 5px 5px #e2e2e2;
}
</style>
