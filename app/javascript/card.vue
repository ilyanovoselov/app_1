<template>
  <div class='card' v-on:click="isActive = !isActive" v-bind:class="{ active: isActive }">
    <div  class="card-face card-back">
    </div>
    <div class="card-face card-front" :style="{ backgroundImage: `url(${card_data.src})` }" :alt="card_data.name">
    </div>
  </div>
</template>

<script>
export default {
  name: 'Card',
  props: ['card_data'],
  data: function () {
    return {
      message: "Card message",
      isActive: false
    }
  }
}
</script>

<style scoped>
.card{
  width:110px;
  height: 110px;
  margin:5px;
  cursor: pointer;
  box-shadow: 0 0 5px 2px #cfcfcf;
  display: inline-block;
  transition: all 0.3s;

  transition-timing-function:  cubic-bezier(.27,-0.34,.73,1.03);
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

.card-front{
  transform: rotateY(180deg);

}
.card-back{
  z-index: 2;
  background-image: url('/images/memo/memo_card_back.png');
}

.card:hover{
  transform:scale(1.02);
  box-shadow: 0 0 6px 1px #cfcfcf;
}

.card.active{
  transform: rotateY(180deg);
}

.card.active:hover{
  transform: rotateY(180deg) scale(1.02);
}
</style>
