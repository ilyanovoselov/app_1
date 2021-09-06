<template>
  <div id="app" v-bind:class="[deskClass]">

      <div class="menu_burger" v-bind:class="{ opened:seenMenu, temp_hide:gameInit }" v-on:click="showMenu()"><span></span><span></span><span></span></div>
      <div v-if="seenMenu" id="menu">
        <button class="primary" v-on:click="startGame()">Start game</button>
        <button class="primary" v-on:click="showSettings()">Settings</button>
      </div>
      <div v-if="seenSettings" id="settings">
        <button class="primary" v-on:click="setField(16)" v-bind:class="{'selected':deskClass =='size_16'}">Поле 16</button>
        <button class="primary" v-on:click="setField(36)" v-bind:class="{'selected':deskClass =='size_36'}">Поле 36</button>
        <button class="primary" v-on:click="toggleSounds()" v-bind:class="{'selected':enableAudio }">Звуки</button>
          <ul>
            <li v-on:click="showSettings()">Назад </li>
            <li>Настройка 1</li>
            <li>Настройка 2</li>
            <li>Настройка 3</li>
            <li>Настройка 4</li>
          </ul>
      </div>

    <desk v-bind:seen_desk="seenDesk" v-bind:size="size" v-bind:enableAudio="enableAudio"></desk>
  </div>
</template>

<script>
import Card from './card'
import Desk from './desk'

export default {
  components: {Card,Desk},
  data: function () {
    return {
      deskClass: 'size_36',
      size:36,
      message: "desk!",
      seenMenu: true,
      seenDesk: false,
      seenSettings: false,
      gameInit:true,
      enableAudio:true
    }
  },
  created(){

  },
  methods: {
    startGame: function(){
      this.gameInit = false;
      this.seenMenu = false;
      this.seenDesk = true;
    },
    showSettings: function(){
      // this.seenDesk = false;
      this.seenSettings = !this.seenSettings;
    },
    showMenu: function(){
      // this.seenDesk = false;
      this.seenSettings = false;
      this.seenMenu = !this.seenMenu;
    },
    setField: function (newsize) {
      this.size = newsize;
      this.deskClass = 'size_'+this.size;
    },
    toggleSounds: function () {
      this.enableAudio = !this.enableAudio;
    }
  },
  computed:{

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
  #app button{
    font-family: fantasy;
    font-family: 'Roboto', sans-serif;
  }
  #menu button.primary{
    cursor:pointer;

    width:100%;
    text-align: center;
    border:none;
    background-color: #72c3f7;
    padding:10px 30px;
    color:white;
    margin:5px 0;
    font-size:18px;
  }

  #menu button.primary:hover{
    background-color: #5fa9d9;
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

  .menu_burger span:nth-child(3){
    transform-origin: 0% 100%;
  }

  .menu_burger.temp_hide{
    opacity: 0;
  }
  .menu_burger.opened span{
    background: #68a4d0;
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

  #settings button.primary{
    cursor:pointer;
    border:none;
    background-color: #72c3f7;
    color:white;
    padding:10px 20px;
    border-radius: 1px;
    transition: all 0.2s ease-out;
    margin:3px 1px;
    font-size: 18px;
  }
  #settings button.primary:hover{
    background-color: #5fa9d9;
  }

  #settings button.primary.selected{
    background-color: #68a4d0;
    /* pointer-events: none; */
  }
</style>
