<template>
  <div id="app" v-if="seen">
    <p>{{ message }}</p>

    <div v-for="img in images" class="card" :style="{ backgroundImage: `url(${img.src})` }" :alt="img.name">
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

<style scoped>
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
  box-shadow: 0 0 5px 2px #cfcfcf;
  display: inline-block;
  background-repeat: no-repeat;
  background-size: 100%;
  background-position: center;
}
</style>
