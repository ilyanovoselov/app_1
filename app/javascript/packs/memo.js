// import Vue from 'vue'
import Vue from 'vue/dist/vue.esm' //version with template compiler (for multicomponent template render usage)
import Velocity from "velocity-animate";
import _ from "lodash";

import App from '../memo.vue'

document.addEventListener('DOMContentLoaded', () => {

  window.app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app);
})
