// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm' //version with template compiler (for multicomponent template render usage)

import App from '../memo.vue'

document.addEventListener('DOMContentLoaded', () => {

  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})
