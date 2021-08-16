// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm' //version with template compiler (for multicomponent template render usage)

import App from '../memo.vue'

document.addEventListener('DOMContentLoaded', () => {

  Vue.component('card', {
    props: ['card_data'],
    template:'<div class="card"><div  class="card-face card-front" :style="{ backgroundImage: `url(${card_data.src})` }" :alt="card_data.name"></div><div class="card-face card-back"></div></div>'

    // template:`
    //   <div class='card'>
    //       <div class="card-face card-front" :style="{backgroundImage:'url(card_data.src)'}" :alt="card_data.name" :data-src="card_data.src">
    //       </div>
    //       <div  class="card-face card-back">
    //       </div>
    //   </div>
    // `,

  })

  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})
