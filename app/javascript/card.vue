<template>
  <div class='card' v-on:click="cardSelect" v-bind:class="classObject">
    <div  class="card-face card-back">
    </div>
    <div class="card-face card-front" :style="{ backgroundImage: `url(${card_data.src})` }" :alt="card_data.name">
    </div>
  </div>
</template>

<script>
export default {
  name: 'Card',
  props: ['card_data','custom_index'],
  data: function () {
    return {
      message: "Card message",
      pair_id: this.card_data.pair_id,
      // status: this.card_data.status
      // card_key:this.custom_index
      // this._uid
    }
  },
  computed: {
    classObject: function () {
        return {
        'active': !this.status=='',
        'passed': this.status=='pass'
      }
    },
    status: function () {
      return this.card_data.status
    },
    cardCoord: function(){
      return {
        x: this.$el.getBoundingClientRect().left,
        y: this.$el.getBoundingClientRect().top
      }
    }
  },
  methods: {
    cardSelect: function (){
      this.$emit('select', {'card_id':this.custom_index, 'pair_id':this.pair_id});
    },
    setCard(type){
      if(type){
        console.log('passed!');
      }else{
        this.isActive = false;
      }

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

.card.passed{
  filter: hue-rotate(292deg);
  opacity: 0;
  /* animation-duration: 0.3s;
  animation-name: passcard; */
}

@keyframes passcard {
  0{
    opacity:1;
  }

  50%{
    filter: hue-rotate(292deg);
    opacity:1;
  }

  100% {
    opacity:0;
  }
}

</style>
