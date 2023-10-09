<template>
  <div class='card' v-on:click="cardSelect" v-bind:class="classObject" v-bind:style="{ transform: 'rotate('+ card_rotate+')'}" v-long-press="500" @long-press-start="onLongPressStart">
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
      card_coord: {},
      // status: this.card_data.status
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
    visited: function() {
      return this.card_data.visited
    },
    card_index: function() {
      return this.card_data.index
    },
    pair_id: function() {
      return this.card_data.pair_id
    },
    card_rotate:  function() {
      return this.card_data.rotate
    }
  },
  methods: {
    cardSelect: function (){
      if (this.status == ''){
        this.$emit('select', {'card_id':this.custom_index, 'pair_id':this.pair_id,'player_id':0});
      }
    },
    cardCoord: function(){
      this.card_coord = {
        x: this.$el.getBoundingClientRect().left + this.$el.offsetWidth/2,
        y: this.$el.getBoundingClientRect().top + this.$el.offsetHeight/2
      }
    },
    onLongPressStart () {
      if (this.status == 'pending'){
        let clean_name = this.card_data.name.slice(0, this.card_data.name.indexOf('.'));
        clean_name = clean_name.split('_').join(' ');
        // clean_name = _.capitalize(clean_name);
        clean_name = _.upperFirst(clean_name);

        let hires_src = this.card_data.src.substring(0,this.card_data.src.lastIndexOf('/')) + '_high'+ this.card_data.src.substring( this.card_data.src.lastIndexOf('/'));
        console.log(hires_src);
        this.$emit('modal', {'card_src':hires_src, 'state':true, 'name':clean_name, 'coords': this.card_coord});
      }
    },
  },
  updated: function(){
    this.cardCoord();
  },
  mounted: function(){
    this.cardCoord();
  },
  watch:  {
    status: function(){
      // console.log(this.status);
      if (this.status == 'pending'){
        this.$el.style.transform = '';
      }
    }
  }
}
</script>

<style scoped>

.card{
  margin:1px;
  cursor: pointer;
  box-shadow: 0 0 5px 2px #0000000a;
  display: block;
  float: left;
  transition: transform 0.3s, filter 0.3s;
  transition-timing-function:  cubic-bezier(.27,-0.34,.73,1.03);
  transform-style: preserve-3d;
  /* transform-origin: center right; */
  position: relative;
}

#app.size_16 .card{
  width: 24.5%;
  height: 24.5%;
}

#app.size_36 .card{
  width: 16.4%;
  height: 16.4%;
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

.classic-gallery .card-back{
  filter: hue-rotate(160deg);
}

.card:hover{
  transform:scale(1.02);
  box-shadow: 0 0 6px 1px #cfcfcf;
}

.card.active{
  transform: rotateY(180deg);
  /* pointer-events: none; */
}

.card.active:hover{
  transform: rotateY(180deg) scale(1.02);
}

.card.passed{
  filter: hue-rotate(292deg);
  opacity: 0;
  pointer-events: none;
  /* animation-duration: 0.3s;
  animation-name: passcard; */
}

.unplayable .card{
  pointer-events: none;
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
@media(max-width:600px){
  .card{
    margin:0;
    box-shadow: none;
  }

  .card:hover{
    box-shadow: none;
  }
}

</style>
