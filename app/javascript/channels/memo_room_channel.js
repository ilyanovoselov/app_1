import consumer from "./consumer"

const memoRoomChannel = consumer.subscriptions.create("MemoRoomChannel", {
  connected() {
    console.log("Connected to the memo room!");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
    if (data.message){
      window.app.$children[0].receiveMessage(data.messageID, data.message, data.author_name, data.author_id);
    } else if(data.user_name){
      window.app.$children[0].receiveAnnounce(' has joinded', data.user_name, data.author_id, data.type, data.messageID);
    }
    // Called when there's incoming data on the websocket for this channel
  },

  speak(data) {
    // console.log(data);
    this.perform('speak', { message:data.message, name:data.name, player_id:data.player_id, messageID:data.messageID })
  },

  announce(content) {
    // console.log(content);
    this.perform('announce', { name: content.name, type: content.type, player_id: content.player_id, messageID:content.messageID})
  }
});

export default memoRoomChannel;
