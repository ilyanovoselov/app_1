<template>
  <div id="desk" v-if="seen" v-bind:class="[deskPlayable]" v-bind:style="{height:deskHeight}">
    <p id="mes_hide">{{ message }}</p>
    <div class="players-panel"><div v-for="player in players" v-bind:class="player.class" >{{ player.name }} : {{ player.score }}</div></div>
    <card v-for="(img,index) in images" v-bind:key="img.id" v-bind:card_data="img" v-bind:custom_index="index" v-bind:gallery="gallery" @select="rememberSelected" @modal="showCardModal" ref="cardChild"></card>

    <div class="modal-cape" v-bind:class="{active:seenModal}" v-on:click="showCardModal({'card_src':'','state':false,'name':''})">
      <div class="card-modal" v-bind:class="{active:seenModal}" ref="modal">
        <img v-bind:src="modalCardSrc" alt="">
        <h2>{{modalCardName}}</h2>
      </div>
    </div>
  </div>
</template>

<script>
import Card from './card'

export default {
  components: {Card},
  props: ['seen_desk','size','enableAudio','gallery','playerName'],
  data: function () {
    return {
      message: "Vue Memo Game!",
      images: [
          {name: 'eltex_1', id: 1, src: 'images/memo/1_eltex/olt-ma4000_px_l.png',status:''},
      ],
      deskPlayable: '',
      totalScore:0,
      selected_cards:[],
      deskHeight: '0px',
      audioShuffle: new Audio('sounds/card_shuffle_single.mp3'),
      audioCardsBack: new Audio('sounds/cards_back.mp3'),
      audioMatch: new Audio('sounds/clean_2.mp3'),
      audioCards:[
        new Audio('sounds/card_single_1.mp3'),
        new Audio('sounds/card_single_2.mp3'),
        new Audio('sounds/card_single_3.mp3'),
        new Audio('sounds/card_single_4.mp3'),
        new Audio('sounds/card_single_5.mp3'),
        new Audio('sounds/card_single_6.mp3'),
      ],
      seenModal:false,
      modalCardSrc:'',
      modalCardName:''
    }
  },
  mounted(){
    // this.getCards(this.size);
  },
  updated(){
    // this.getCards(this.size);
    let desk_width = this.$el.offsetWidth;
    // console.log(desk_width);
    this.deskHeight = desk_width+'px';
  },
  watch: {
    size: function () {
      this.getCards();
    },
    seen_desk: function (){
      if(this.seen_desk){
        this.getCards();
      } else {
        this.resetGame();
      }
    },
    gallery: function () {
      this.getCards();
    },
  },
  computed:{
    screenCenter: function(){
      return {
        x:window.innerWidth/2,
        y:window.innerHeight/2
      }
    },
    seen: function(){
      return this.seen_desk
    },
    players: function(){
      return {
        0: {name:this.playerName,score:0,class:'active'},
        1: {name:'AI',score:0,class:''}
      }
    }
  },
  methods: {
    async getCards() {

      if(this.enableAudio){
        this.audioShuffle.play();
      }

      let url = 'https://novoselovilya.ru/myapp/memo/images?size='+this.size+'&gallery='+this.gallery;
      let response = await fetch(url);
      let data = await response.json();
      let iterator = 0;
      for (var i = 0; i < Math.sqrt(this.size); i++) {
        for (var j = 0; j < Math.sqrt(this.size); j++) {
          data[iterator].card_id = iterator;
          data[iterator].index = {x:j,y:i};
          data[iterator].visited = 0;
          data[iterator].rotate = '0deg';
          iterator++;
        }
      }

      this.images = await data;
      // console.log(this.images);

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
      this.totalScore = 0;
      this.selected_cards = [];
      this.players[0].score = 0;
      this.players[1].score = 0;
      // this.message = "Game has restarted!";
    },
    rememberSelected: function(incoming_card_data){

      this.modalCardSrc = incoming_card_data.card_src;// we need to preload image

      if(this.enableAudio){
        let card_single_sound = _.sample(this.audioCards);
        card_single_sound.play();
      }
      // console.log(incoming_card_data);

      //remember cards visits
      this.images[incoming_card_data.card_id].visited += 1;

      //get card status not empty
      if(this.selected_cards.length == 0){
        //update 1st card
        this.selected_cards[0] = this.images[incoming_card_data.card_id]; // remember 1st card
        this.selected_cards[0].status = 'pending';

        setTimeout(()=>{
          if(incoming_card_data.player_id == 1 ){
            this.message = 'AI turn please wait litle more';
            this.AiLogic();
            // .then( () =>{
            //   this.players[0].class = 'active';
            //   this.players[1].class = '';
            //   }
            // );
          }
        }, 2000);

      } else if(this.selected_cards.length == 1){
        this.deskPlayable = 'unplayable';//turn off desk

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
        let last_guessed_player_id = '';
        if(this.selected_cards[0].pair_id ==this.selected_cards[1].pair_id){

          last_guessed_player_id = incoming_card_data.player_id;
          this.players[incoming_card_data.player_id].score +=2;
          this.totalScore +=2;
          this.message = 'Yeap!';
          temp_message = 'Next turn';
          temp_status = 'pass';
          if(this.enableAudio){
            this.audioMatch.play();
          }

          if(this.totalScore == this.size){
            this.message = 'Congratulations!';
            temp_message = 'Game Over';
          }
        } else {
          this.message = 'Wrong guess!';
          temp_message ='Please select another pair';
          temp_status = ''
        }

        setTimeout(()=>{

          if(temp_status ==''){;
              let rotate_factor;
              rotate_factor =  (_.random(0,1)) ? _.random(-1.5, -1) : _.random(1, 1.5);
              this.selected_cards[0].rotate =  rotate_factor+"deg";
              rotate_factor =  (_.random(0,1)) ? _.random(-1.5, -1) : _.random(1, 1.5);
              this.selected_cards[1].rotate =  rotate_factor+"deg";

              if(this.enableAudio){
                this.audioCardsBack.play();
              }
          }

          if(temp_status=='pass'){
            if(this.enableAudio){
              this.audioCardsBack.play();
            }
          }

          this.message = temp_message;
          this.selected_cards[0].status = temp_status;
          this.selected_cards[1].status = temp_status;
          this.selected_cards=[];

          if(this.totalScore == this.size){ // show all cards after game is completed
            Object.entries(this.images).forEach(([key, image_object]) => {
              Object.keys(image_object).forEach(function(key){ image_object['status'] = "pending" });
            });
          }
        }, 3500);

        setTimeout(()=>{

          if(incoming_card_data.player_id == 0 && last_guessed_player_id === ''){
            // console.log('turn of player was: '+incoming_card_data.player_id);
            // console.log('guessed player: '+last_guessed_player_id);
            this.message = 'AI turn please wait';
            this.AiLogic();
            this.players[0].class = '';
            this.players[1].class = 'active';
          }

          // console.log(incoming_card_data.player_id );
          // console.log(last_guessed_player_id);
          if(incoming_card_data.player_id === 0 && last_guessed_player_id === 0){
            this.deskPlayable = '';
          }

          if(incoming_card_data.player_id == 1 && last_guessed_player_id === ''){
            this.message = 'Your turn next';
            this.deskPlayable = '';
            this.players[0].class = 'active';
            this.players[1].class = '';
          }

          if(last_guessed_player_id == 1){
            this.message = 'AI turn again. please wait';
            this.AiLogic();
          }
        }, 4000);


      }
    },
    AiLogic: function(){

      let temp_index = [];

      //*) get card_index from pair_id
      temp_index = '';
      if(this.selected_cards.length == 0){
        this.$refs.cardChild.forEach(card_child => {
          if (temp_index.length == 0){ //check if card to pick is already selected
            if(card_child.visited >0 && card_child.status !=='pending' && card_child.status !=='pass'){ // if card visited
              this.$refs.cardChild.forEach(card_child_2 => {
                if(card_child_2.pair_id == card_child.pair_id && card_child_2.custom_index !== card_child.custom_index){ // second card of pair visited too
                  if(card_child_2.visited > 0){
                    temp_index = card_child.card_index;
                    return false;
                  }
                }
              });
            }
          }
        });
      } else {
        this.$refs.cardChild.forEach(card_child_2 => {
          if(card_child_2.pair_id == this.selected_cards[0].pair_id && card_child_2.custom_index !== this.selected_cards[0].card_id){
            if(card_child_2.visited > 0){
              temp_index = card_child_2.card_index;
              return false;
            }
          }
        });
      }

      if (temp_index.length == 0){
        // console.log('visited pair not found:(');
        //*) pick random card
        let choosable_cards = [];
        this.$refs.cardChild.forEach(card_child => {
          if(card_child.status !== 'pass' && card_child.status !== 'pending'){
              choosable_cards.push(card_child);
          }
        });
        temp_index = _.sample(choosable_cards).card_index;
      }

      // console.log(temp_index);

      let guess_card_indeces_array = [];
      //*) create zone array
      // let difficulty = 1;
      // let  difficulty = 0;
      let  difficulty = _.random(0, 1);
      // console.log(difficulty);
      for (var i = -difficulty; i <= difficulty; i++) {
        for (var j = -difficulty; j <=difficulty; j++) {
          if(temp_index.x + i > -1 && temp_index.x + i < Math.sqrt(this.size) && temp_index.y + j > -1 && temp_index.y + j < Math.sqrt(this.size) ){ // edges of desk
            this.$refs.cardChild.forEach(card_child => {
              if( card_child.card_data.status != 'pass' && card_child.card_data.status != 'pending' && temp_index.x + i == card_child.card_index.x && temp_index.y + j == card_child.card_index.y){
                guess_card_indeces_array.push({
                  x: temp_index.x + i,
                  y: temp_index.y + j,
                  id: card_child.custom_index,
                  pairID: card_child.pair_id
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
        {'card_id':new_guess.id, 'pair_id':new_guess.pairID, 'player_id':1}
      );
    },
    showCardModal: function( data ){
        if(data.state != false){
          let $modal = this.$refs.modal;
          let temp_x = $modal.getBoundingClientRect().left + $modal.offsetWidth/2  - data.coords.x;
          let temp_y = $modal.getBoundingClientRect().top + $modal.offsetHeight/2  - data.coords.y;
          // console.log($modal.getBoundingClientRect().left + $modal.offsetWidth/2);
          // console.log($modal.getBoundingClientRect().top + $modal.offsetHeight/2);
          $modal.style.transform = 'translateX('+temp_x*(-1)+'px)'+' translateY('+temp_y*(-1)+'px)'+' scale(0.1)';
          setTimeout(()=>{
            this.seenModal = data.state;
            this.modalCardName = data.name;
            this.$refs.modal.style.transform = 'translateX(0) translateY(0) scale(1)';
          },300);
          // Velocity(this.$refs.modal.$el, {translateX: "0",translateY:"0"});
          //Velocity(card_child.$el, 'reverse');
        } else {
          this.seenModal = data.state;

          this.modalCardName = data.name;
        }
    }
  }
}
</script>

<style scoped>
#desk {
  box-sizing: border-box;
  width:100%;
}
#app.size_16 #desk{
  height: 650px;
}
#app.size_36 #desk{
  height: 1000px;
}

@media(max-width:1024px){
  #desk{
    width:100%;
  }
}

p {
  font-size: 2em;
  text-align: center;
}

.players-panel{
  width:100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 36px;
}

.players-panel div{
  font-weight: bold;
  transition: all 0.4s ease-out;
  text-align: center;
  font-size: 19px;
}
.players-panel div.active{
  font-size: 28px;
}

@media(max-width:600px){

  p {
    font-size:  1.2em;
    text-align: center;
  }

  .players-panel div.active{
    font-size: 24px;
  }
}

.modal-cape{
  cursor:pointer;
  transition: all 0.3s;
  opacity: 0;
  position: fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background-color: #000000aa;
  pointer-events: none;
  z-index: 2;
}

.modal-cape.active{
  opacity: 1;
  pointer-events: all;
}

.card-modal{
  transition: all 0.3s cubic-bezier(.2,.05,1,.43);
  transform: scale(1);
  padding-top:100px;
  width:700px;
  height:700px;
  margin:auto;
  pointer-events: none;
  color: white;
}

.card-modal img{
  width: 100%;
  /* width:400px;
  height:400px;
  margin: auto; */
}
 @media(max-width:700px){
   .card-modal{
     /* width:90%;
     height:auto; */
     width:300px;
     height:300px;
   }
 }

 #mes_hide{
   display:none;
 }

</style>
