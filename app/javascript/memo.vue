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


.card{
  width:110px;
  height: 110px;
  margin:5px;
  cursor: pointer;
  box-shadow: 0 0 5px 2px #cfcfcf;
  display: inline-block;
  transition: all 0.3s;
  transform-style: preserve-3d;
  /* transform-origin: center right; */
  position: relative;
}

.card-face{
  width: 100%;
  height: 100%;
  background-repeat: no-repeat;
  background-size: 100%;
  background-position: center;
  display: block;

  -webkit-backface-visibility: hidden;
  position: absolute;
  top: 0;
  left: 0;
}

.card-back{
  transform: rotateY(180deg);
  z-index: 2;
  background-color:grey;
}

.card:hover{
  transform:scale(1.02);
  box-shadow: 0 0 6px 1px #cfcfcf;
  /* transform: rotateY(180deg); */
}
</style>
