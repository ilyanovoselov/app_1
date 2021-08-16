<template>
  <div class='card'>
    <div class="card-face card-front" :style="{ backgroundImage: `url(${card_data.src})` }" :alt="card_data.name" :data-src="card_data.src">
    </div>
    <div  class="card-face card-back">
    </div>
  </div>
</template>

<script>
export default {
  name: 'Card',
  props: ['card_data'],
  data: function () {
    return {
      message: "Card message"
    }
  }
}
</script>

<style scoped>
.card-component {
  background-color: cyan;
}
</style>
