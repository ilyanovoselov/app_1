<template>
  <div id="app" v-bind:class="[deskClass,gallery_class]" >

      <div class="menu_burger" v-bind:class="{ opened:seenMenu, temp_hide:gameInit }" v-on:click="showMenu()"><span></span><span></span><span></span></div>
      <div v-if="seenMenu" id="menu">
        <button class="btn-primary" v-on:click="startGame()">Start game</button>
        <button class="btn-primary" v-on:click="showSettings()">Settings</button>
        <button class="btn-primary" v-on:click="showChat()" v-bind:class="{'selected':seenChat}">Chat</button>
      </div>
      <div v-if="seenSettings" id="settings">
        <button class="btn-primary" v-on:click="showSettings()"> < </button>
        <button class="btn-primary" v-on:click="setField(16)" v-bind:class="{'selected':deskClass =='size_16'}">Поле 16</button>
        <button class="btn-primary" v-on:click="setField(36)" v-bind:class="{'selected':deskClass =='size_36'}">Поле 36</button>
        <button class="btn-primary" v-on:click="toggleSounds()" v-bind:class="{'selected':enableAudio }">Звуки</button>
        <button class="btn-primary" v-on:click="changeGallery('1_eltex')" v-bind:class="{'selected':gallery =='1_eltex'}">Элтекс</button>
        <button class="btn-primary" v-on:click="changeGallery('2_paintings_classic')" v-bind:class="{'selected':gallery =='2_paintings_classic'}">Классика</button><br>

        <button v-for="(audio,index) in audioChat" v-bind:key="index" class="btn-primary" v-bind:class="{'selected':index ==audioChatIndex}" v-on:click="setAudio(index)">{{audio.name}}</button>

        <div class="input_desk">
          <input v-model="playerName" type="text">
          <button class="btn-primary send_button" v-on:click="getNickname()"> ⟲ </button>
        </div>

      </div>
      <div v-if="seenChat" id="chat">
        <button class="btn-primary" v-on:click="showChat()"> < </button>
        <div class="chat_desk">
          <div v-for="(message,index) in messages" v-bind:key="message.id" v-bind:id="message.mess_id" v-on:click="readMessage(message.mess_id)" class="chat_message" v-bind:class="[message.type, { red:message.status}]">
            <span class="message_text">
              <span class="message_author">{{message.author}}</span>
              {{message.text}}
            </span>
          </div>
        </div>
        <div v-bind:class="{active:typingUsersActive}" class="users_typing"> {{typingUsersText}} </div>
        <div class="input_desk">
          <input v-model="tempMessage" type="text" v-on:blur="sendBlur()" v-on:focus="sendFocus()">
          <button class="btn-primary send_button" v-on:click="sendMessage()"> > </button>
        </div>
      </div>

    <desk v-bind:seen_desk="seenDesk" v-bind:size="size" v-bind:enableAudio="enableAudio" v-bind:gallery="gallery" v-bind:playerName="playerName"></desk>
  </div>
</template>

<script>
import Card from './card'
import Desk from './desk'
import memoRoomChannel from "./channels/memo_room_channel";

export default {
  components: {Card,Desk},
  data: function () {
    return {
      deskClass: 'size_36',
      size:36,
      tempMessage: '',
      playerID:_.random(0,100),
      playerName: 'Player',
      messages: [
        // {mess_id:3232,status:false, text:'Hello!',author:"Melancholic Panda",type:"incoming"},
      ],
      typingUsers:[],
      seenMenu: true,
      seenDesk: false,
      seenSettings: false,
      seenChat: false,
      gameInit:true,
      enableAudio:true,
      gallery:'2_paintings_classic',
      audioChat:[
        {audio:new Audio('sounds/junitos.mp3'),name:'Junitos'},
        {audio:new Audio('sounds/to-the-point.mp3'),name:'Point'},
        {audio:new Audio('sounds/clean_2.mp3'),name:'Clean'},
        {audio:new Audio('sounds/cards_back.mp3'),name:'2 Cards'}
      ],
      audioChatIndex:0
    }
  },
  mounted(){
    // memoRoomChannel.announce({ name:this.playerName, type: 'join'})
    if (localStorage.playerName) {
      this.playerName = localStorage.playerName;
    } else {
      this.getNickname();
    }
  },
  methods: {
    startGame: function(){
      this.gameInit = false;
      this.seenMenu = false;
      this.seenDesk = true;
    },
    showSettings: function(){
      this.seenMenu = !this.seenMenu;
      this.seenSettings = !this.seenSettings;
    },
    showMenu: function(){
      // this.seenDesk = false;
      this.seenSettings = false;
      this.seenChat = false;
      this.seenMenu = !this.seenMenu;
    },
    showChat: function (){
      this.seenSettings = false;
      this.seenMenu = !this.seenMenu;
      this.seenChat = !this.seenChat;
    },
    setField: function (newsize) {
      this.size = newsize;
      this.deskClass = 'size_'+this.size;
    },
    toggleSounds: function () {
      this.enableAudio = !this.enableAudio;
    },
    changeGallery: function (new_gallery) {
      this.gallery = new_gallery;
    },
    sendMessage: function (){
      let new_message_id = _.random(10000,100000000000);
      memoRoomChannel.speak({message:this.tempMessage, name:this.playerName, player_id:this.playerID,messageID:new_message_id});
      // memoRoomChannel.announce({ name:this.playerName, type: 'join'})

      this.tempMessage = '';
    },
    sendFocus(){
      if(this.tempMessage.length > 0){}
        memoRoomChannel.announce({ name:this.playerName, player_id:this.playerID, type: 'focus'});
    },
    sendBlur(){
      memoRoomChannel.announce({ name:this.playerName, player_id:this.playerID, type: 'blur'});
    },
    receiveMessage: function (messageID,mess,author_name,author_id){
      let temp_type = '';
      if(author_id == this.playerID){
        temp_type = 'outgoing';
      } else if(author_id != this.playerID){
        temp_type = 'incoming';
      }

      this.messages.push({mess_id:messageID,status:false,text:mess,type:temp_type,author:author_name});

      var scroll_container = this.$el.querySelector(".chat_desk");

      setTimeout(()=>{
        scroll_container.scrollTop = scroll_container.scrollHeight;
        if(this.enableAudio && temp_type == 'incoming'){
          this.audioChat[this.audioChatIndex].audio.play();
        }
      },10);
    },
    receiveAnnounce: function (mess,author_name,author_id,announce_type, mess_id){
      if(announce_type=='focus'){
        if(author_id != this.playerID){
          this.typingUsers.push({id:author_id, name: author_name});
        }
      } else if(announce_type =='blur') {
        this.typingUsers = this.typingUsers.filter(function(item) {
            return item.id !== author_id
        })
      } else if(announce_type =='read_message'){
        this.messages.forEach((message) => {
            if(message.mess_id == mess_id){
              message.status = true;
            }
          }
        );
      }
    },
    readMessage: function(mess_id){

      // this.messages.forEach( (message) => {
      //     if(message.mess_id == mess_id){
      //       message.status = true;
      //     }
      //   }
      // );
      memoRoomChannel.announce({ name:this.playerName, player_id:this.playerID, type: 'read_message', messageID: mess_id});
    },
    async getNickname(){
      let url = 'https://novoselovilya.ru/myapp/nicknames';
      let response = await fetch(url);
      let data = await response.json();
      this.playerName = data.property.charAt(0).toUpperCase() + data.property.slice(1) +' '+ data.animal.charAt(0).toUpperCase() + data.animal.slice(1);
    },
    setAudio: function(newAudioIndex){
      this.audioChatIndex = newAudioIndex;

      if(this.enableAudio){
        this.audioChat[newAudioIndex].audio.play();
      }
    }
  },
  computed:{
    gallery_class:function () {
      return {
        'classic-gallery': this.gallery=='2_paintings_classic'
      };
    },
    typingUsersActive: function (){
      return this.typingUsers.length > 0
    },
    typingUsersText: function (){
      let temp_txt_typing;
      temp_txt_typing = this.typingUsers.length+' user';
      temp_txt_typing += this.typingUsers.length > 1 ? 's are' : ' is';
      temp_txt_typing += ' typing ...';
      return temp_txt_typing;
    }
  },
  watch: {
    playerName(newName) {
      localStorage.playerName = newName;
    },
    tempMessage: function(){
      if (this.tempMessage.length <1){
        this.sendBlur();
      }
    }
  }
}
</script>

<style scoped>
  @import url('https://fonts.googleapis.com/css?family=Roboto+Condensed');
  #app{
    margin-top:20px;
    margin-left: auto;
    margin-right: auto;
    box-sizing: border-box;
    font-family: fantasy;
    font-family: 'Roboto', sans-serif;

    -webkit-touch-callout: none; /* iOS Safari */
    -webkit-user-select: none; /* Safari */
     -khtml-user-select: none; /* Konqueror HTML */
       -moz-user-select: none; /* Old versions of Firefox */
        -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none;
  }

  #app.size_16{
    width: 650px;
  }
  #app.size_36{
    width: 1000px;
  }

  @media(max-width:1200px){
    #app{
      width:100% !important;
    }
  }

  #app.size_36 #menu button{
      width:50%;
      margin-left: auto;
      margin-right: auto;
  }
  @media(max-width:700px){
    #app.size_36 #menu button{
        width:100%;
    }
  }
  #app button{
    font-family: fantasy;
    font-family: 'Roboto', sans-serif;
  }
  #menu button.btn-primary{
    cursor:pointer;
    width:100%;
    text-align: center;
    padding:10px 30px;
    margin:5px 0;
    font-size:18px;
  }

  .menu_burger{
    cursor: pointer;
  }
  .menu_burger span{
    display: block;
    width: 33px;
    height: 4px;
    margin-bottom: 5px;
    position: relative;
    background: #72c3f7;
    z-index: 1;
    transform-origin: 4px 0px;
    transition: transform 0.5s cubic-bezier(0.77,0.2,0.05,1.0),
              background 0.5s cubic-bezier(0.77,0.2,0.05,1.0),
              opacity 0.55s ease;
  }

  .classic-gallery .menu_burger span{
    background-color: #ff9c8b;
  }

  .menu_burger span:nth-child(3){
    transform-origin: 0% 100%;
  }

  .menu_burger.temp_hide{
    opacity: 0;
  }
  .menu_burger.opened span{
    background: #68a4d0;
  }
  .classic-gallery .menu_burger.opened span{
    background: #db6652;
  }

  .menu_burger.opened span:first-child{
    transform: rotate(45deg) translate(-2px, -1px);
  }
  .menu_burger.opened span:nth-child(2){
    opacity: 0;
    transform: rotate(0deg) scale(0.2, 0.2);
  }

  .menu_burger.opened span:nth-child(3){
    transform: rotate(-45deg) translate(0, -1px);
  }

  #settings button.btn-primary{
    cursor:pointer;
    padding:10px 20px;
    border-radius: 1px;
    transition: all 0.2s ease-out;
    margin:3px 1px;
    font-size: 18px;
  }

  button.btn-primary{
    color:white;
    border:none;
    background-color: #72c3f7;
  }

  button.btn-primary:hover{
    background-color: #5fa9d9;
  }

  button.btn-primary.selected{
    background-color: #68a4d0;
  }

  .classic-gallery  button.btn-primary{
    background-color: #ff9c8b;
  }

  .classic-gallery button.btn-primary:hover{
    background-color: #fa8c79;
  }
  .classic-gallery  button.btn-primary.selected{
    background-color: #db6652;
  }
  #chat{
    width: 50%;
  }
  @media(max-width:700px){
    #chat{
      width: 100%;
    }
  }
  #chat .chat_desk{
    height:200px;
    overflow-y: scroll;
  }
  #chat .chat_desk{
    text-align: right;
  }

  #chat .chat_desk .chat_message.outgoing{
      text-align: right;
  }
  #chat .chat_desk .chat_message.incoming{
      text-align: left;
  }
  #chat .chat_desk .chat_message.announce{
      text-align: center;
  }
  #chat .chat_desk .chat_message.outgoing .message_text{
      color:white;
      background-color: #36e556;
  }
  #chat .chat_desk .chat_message.incoming .message_text{
    background-color: #ececec;
  }

  #chat .chat_desk .chat_message.announce .message_text{
    font-size: 10px;
    color:grey;
  }
  #chat .chat_desk .chat_message.announce .message_author{
    color:black;
    font-weight: bold;
    font-size: 14px;
  }
  #chat .chat_desk .message_text{
    display: inline-table;
    margin: 5px 10px;
    padding: 10px 20px;
  }
  #chat .chat_desk .chat_message .message_author{
    font-size: 10px;
  }
  #chat .chat_desk .chat_message.incoming .message_author{
    color:grey;
  }
  #chat .chat_desk .chat_message.outgoing .message_author{
    color:white;
  }
  #chat .chat_message:before{
    content:' ';
    background-color: #ff5077;
    border-radius: 50%;
    width:15px;
    height:15px;
    display: inline-block;
    bottom: 13px;
    left: 20px;
    position: relative;
    opacity: 1;
    transition:all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    transform:scale(1);
  }
  #chat .chat_message.red:before{
    opacity: 0;
    transform:scale(0.1);
  }
  #chat button.btn-primary{
    cursor:pointer;
    padding:10px 20px;
    transition: all 0.2s ease-out;
    margin:3px 1px;
    font-size: 18px;
  }

  .input_desk{
    border-color: #e2e2e2 !important;
    display: flex;
    justify-content: space-between;
  }

  .input_desk input{
    border-radius: 0 !important;
    width:80%;
    margin:none;
    height: 50px;
    font-size: 16px;
  }
  .input_desk .send_button{
    width:20%;
  }

  .users_typing{
    position: relative;
    bottom: 10px;
    text-align: center;
    color: grey;
    transition: all 0.3s;
    opacity:0;
    transform:scale(0.1);
  }

  .users_typing.active{
    opacity:1;
    transform: scale(1);
  }


</style>
