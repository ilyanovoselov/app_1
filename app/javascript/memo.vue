<template>
  <div id="app" v-if="seen" v-bind:class="[activeClass]">
    <button v-on:click="setField(16)" >Поле 16</button>
    <button v-on:click="setField(36)" >Поле 36</button>
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
      ],
      size:16,
      activeClass: 'size_16'
    }
  },
  created(){
    this.getCards(this.size);
  },
  methods: {
    setField: function (newsize) {
      this.size = newsize;
      this.activeClass = 'size_'+this.size;
      this.getCards(this.size);
    },
    async getCards() {
      let url = 'http://novoselovilya.ru/memo/images?size='+this.size;
      let response = await fetch(url);
      let data = await response.json();
      this.images =  data;
      console.log(data);
    }
  }
}
</script>

<style scoped>
#app{
  width:500px;
  margin-left: auto;
  margin-right: auto;;
}
#app.size_36{
  width: 750px;
  margin-left: auto;
  margin-right: auto;;
}
p {
  font-size: 2em;
  text-align: center;
}
</style>
