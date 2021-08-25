<template>
  <div id="desk" v-if="seen" v-bind:class="[activeClass]">
    <!-- <button class="primary" v-on:click="setField(4)" >Поле 4</button> -->
    <button class="primary" v-on:click="setField(16)" >Поле 16</button>
    <button class="primary" v-on:click="setField(36)" >Поле 36</button>
    <button class="primary" v-on:click="tossCards()" >Перетасовать</button>
    <button class="primary" v-on:click="AiLogic(1)" >AI turn 1</button>
    <button class="primary" v-on:click="AiLogic(2)" >AI turn 2</button>
    <p>{{ message }}</p>
    <card v-for="(img,index) in images" v-bind:key="img.id" v-bind:card_data="img" v-bind:custom_index="index" @select="rememberSelected" ref="cardChild"></card>
  </div>
</template>

<script>
import Card from './card'

export default {
  components: {Card},
  props: ['desk_data'],
  data: function () {
    return {
      message: "Vue Memo Game!",
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
      let iterator = 0;
      console.log(data);
      for (var i = 0; i < Math.sqrt(this.size); i++) {
        for (var j = 0; j < Math.sqrt(this.size); j++) {
          data[iterator].index = {x:i,y:j};
        }
      }

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
      // this.message = "Game has restarted!";
    },
    rememberSelected: function(incoming_card_data){
      // console.log(incoming_card_data);
      //remember cards visits
      this.visitedCards[incoming_card_data.card_id] += 1;
      this.visitedPairs[incoming_card_data.pair_id] += 1;
      console.log(this.visitedPairs);
      //get card status not empty
      if(this.selected_cards.length == 0){
        //update 1st card
        this.selected_cards[0] = this.images[incoming_card_data.card_id]; // remember 1st card
        this.selected_cards[0].status = 'pending';

      } else if(this.selected_cards.length == 1){

        //check for click on current active card
        if(this.selected_cards[0].card_id == incoming_card_data.card_id){
          this.message = 'Please choose another card';
          return false;
        }
        //update 2nd card
        this.selected_cards[1] = this.images[incoming_card_data.card_id]; // remember 2d card
        this.selected_cards[1].status = 'pending';

        let temp_status = '';
        let temp_message = '';
        if(this.selected_cards[0].pair_id ==this.selected_cards[1].pair_id){
          this.score +=2;
          this.message = 'Yeap!';
          temp_message = 'Your score is: '+this.score;
          temp_status = 'pass';
          if(this.score == this.size){
            this.message = 'Congratulations!';
          }
        } else {
          this.message = 'Wrong guess!';
          temp_message ='Please select another pair';
          temp_status = ''
        }

        setTimeout(()=>{
          this.message = temp_message;
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
    },
    AiLogic: function(turn){

      let temp_index = [];
      //make 1st turn
      if(turn == 1){
        //*) check for most visited cards
        var indexOfMostVisitedCard = this.visitedCards.reduce((iMax, x, i, arr) => x > arr[iMax] ? i : iMax, 0);
        console.log(indexOfMostVisitedCard);
        //*) get its index
        temp_index = this.$refs.cardChild[indexOfMostVisitedCard].card_index;
        console.log(temp_index);
      }else{
        //make second turn
        //*) check for known pairs
        var indexOfMostVisitedPair = this.visitedPairs.reduce((iMax, x, i, arr) => x > arr[iMax] ? i : iMax, 0);

        console.log(indexOfMostVisitedPair);

        //*) get card id from pair_id
        //temp cards from known pairs
        let pair_from_known_pair = [];
        this.$refs.cardChild.forEach(async card_child => {
            if( card_child.pair_id == indexOfMostVisitedPair){
              pair_from_known_pair.push(card_child.custom_index);
            }
        });

        console.log(pair_from_known_pair);

        let one_of_pair_index = _.sample(pair_from_known_pair);

        temp_index = this.$refs.cardChild[one_of_pair_index].card_index;
      }

      let guess_card_indeces_array = [];
      //*) create zone array
      for (var i = -1; i <= 1; i++) {
        for (var j = -1; j <= 1; j++) {
          if(temp_index.x + i > -1 && temp_index.x + i < Math.sqrt(this.size) && temp_index.y + j > -1 && temp_index.y + j < Math.sqrt(this.size) ){ // edges of desk

            this.$refs.cardChild.forEach(card_child => {
              if( card_child.card_data.status != 'pass' && temp_index.x == card_child.card_index.x && temp_index.y == card_child.card_index.y){
                guess_card_indeces_array.push({
                  x: temp_index.x + i,
                  y: temp_index.y + j,
                  id: card_child.custom_index
                });
              }
            });
          }
        }
      }

      // console.log(guess_card_indeces_array);

      //*) get new guess card index from zone
      let new_guess = _.sample(guess_card_indeces_array);

      //*) virtual click on guess
      this.rememberSelected(
        {'card_id':new_guess.id, 'pair_id':this.$refs.cardChild[new_guess.id].pair_id}
      );

    }
  },
  computed:{
    screenCenter: function(){
      return {
        x:window.innerWidth/2,
        y:window.innerHeight/2
      }
    },
    seen: function(){
      return this.desk_data
    },
    visitedCards: function(){
      return new Array(this.size).fill(0)
    }
  }
}
</script>

<style scoped>
#desk{
  width:100%;
}
#desk.size_36{
  width: 750px;
  margin-left: auto;
  margin-right: auto;
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
  transition: all 0.2s ease-out;
  margin:3px 1px;
}
button.primary:hover{
  background-color: #5fa9d9;
}
</style>
