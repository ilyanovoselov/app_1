<template>
  <div id="app" v-if="seen">
    <p>{{ message }}</p>
    <card v-for="img in images" v-bind:key="img.id" v-bind:card_data="img"></card>
  </div>
</template>

<script>
import Card from './card'

export default {
  components: {Card},
  data: function () {
    return {
      message: "Vue Memo Game!",
      seen: true,
      images: [
          {name: 'eltex_1', id: 1, src: 'images/memo/1_eltex/olt-ma4000_px_l.png'},
      ]
    }
  },
  async created(){
    let url = 'http://novoselovilya.ru/memo/images';
    let response = await fetch(url);
    let data = await response.json();
    this.images =  data;
    console.log(data);
  }
}
</script>

<style>
#app{
  width:500px;
  margin-left: auto;
  margin-right: auto;;
}
p {
  font-size: 2em;
  text-align: center;
}
</style>
