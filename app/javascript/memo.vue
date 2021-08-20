<template>
  <div id="app" v-if="seen" v-bind:class="[activeClass]">
    <button class="primary" v-on:click="setField(4)" >Поле 4</button>
    <button class="primary" v-on:click="setField(16)" >Поле 16</button>
    <button class="primary" v-on:click="setField(36)" >Поле 36</button>
    <button class="primary" v-on:click="tossCards()" >Перетасовать</button>
    <p>{{ message }}</p>
    <card v-for="(img,index) in images" v-bind:key="img.id" v-bind:card_data="img" v-bind:custom_index="index" @select="rememberSelected" ref="cardChild"></card>
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
          {name: 'eltex_1', id: 1, src: 'images/memo/1_eltex/olt-ma4000_px_l.png',status:''},
      ],
      size:16,
      activeClass: 'size_16',
      score:0,
      selected_cards:[]
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
      this.images = await data;
      // console.log(data);
      this.resetGame();

      setTimeout(()=>{
        this.tossCards();
      },100);
    },
    tossCards: function(){
      this.$refs.cardChild.forEach(async card_child => {
        card_child.$el.style.transition = 'none';
        let temp_x = this.screenCenter.x - card_child.card_coord.x;
        let temp_y = this.screenCenter.y - card_child.card_coord.y;
        await Velocity(card_child.$el, {translateX: temp_x+"px",translateY: temp_y+"px"});
        await Velocity(card_child.$el, 'reverse');
        card_child.$el.style='';
      })
    },
    resetGame: function(){
      this.score = 0;
      this.selected_cards = [];
      this.message = "Game has restarted!";
    },
    rememberSelected: function(incoming_card_data){
      // console.log(incoming_card_data);
      //get card status not empty
      if(this.selected_cards.length == 0){
        //update 1st card
        this.selected_cards[0] = this.images[incoming_card_data.card_id]; // remember 1st card
        this.selected_cards[0].status = 'pending';

      } else if(this.selected_cards.length == 1){
        //update 2nd card
        this.selected_cards[1] = this.images[incoming_card_data.card_id]; // remember 2d card
        this.selected_cards[1].status = 'pending';

        let temp_status = '';
        if(this.selected_cards[0].pair_id ==this.selected_cards[1].pair_id){
          console.log('pass');
          temp_status = 'pass';
          this.score +=2;
          this.message = 'Your score is: '+this.score;
          if(this.score == this.size){
            this.message = 'Congratulations!';
          }
        } else {
          console.log('wrong guess');
          temp_status = ''
        }

        setTimeout(()=>{
          this.selected_cards[0].status = temp_status;
          this.selected_cards[1].status = temp_status;
          this.selected_cards=[];

          if(this.score == this.size){ // show all cards after game is completed
            Object.entries(this.images).forEach(([key, image_object]) => {
              Object.keys(image_object).forEach(function(key){ image_object['status'] = "pending" });
            });
          }
        }, 2000);

      }
    }
  },
  computed:{
    screenCenter: function(){
      return {
        x:window.innerWidth/2,
        y:window.innerHeight/2
      }
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

button.primary{
  cursor:pointer;
  border:none;
  background-color: #72c3f7;
  color:white;
  padding:10px 20px;
  border-radius: 1px;
  transiton: all 0.2s ease-out;
}
button.primary:hover{
  background-color: #5fa9d9;
}
</style>
