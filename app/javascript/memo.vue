<template>
  <div id="app" >
    <div id="menu">
      <!-- <button v-on:click="startGame()">Show desk</button> -->
      <!-- <button v-on:click="showSettings()">Settings</button> -->
    </div>

    <div v-if="seenSettings" class="settings">
        <ul>
          <li>Настройка 1</li>
          <li>Настройка 2</li>
          <li>Настройка 3</li>
          <li>Настройка 4</li>
        </ul>
    </div>
    <desk v-bind:desk_data="seenDesk"></desk>
  </div>
</template>

<script>
import Card from './card'
import Desk from './desk'

export default {
  components: {Card,Desk},
  data: function () {
    return {
      message: "desk!",
      seenMenu: true,
      seenDesk: true,
      seenSettings: false
    }
  },
  created(){

  },
  methods: {
    startGame: function(){
      this.seenSettings = false;
      this.seenDesk = !this.seenDesk;
    },
    showSettings: function(){
      this.seenDesk = false;
      this.seenSettings = !this.seenSettings;

    }
  },
  computed:{

  }
}
</script>

<style scoped>
  #app{
    width:500px;
    margin-left: auto;
    margin-right: auto;
  }

  #menu button{
    cursor:pointer;

    width:100%;
    text-align: center;
    border:none;
    background-color: #72c3f7;
    padding:10px 30px;
    font-weight: bold;
    color:white;
    margin:5px 0;
  }

  #menu button:hover{
    background-color: #5fa9d9;
  }
</style>
