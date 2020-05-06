import Vue from 'vue'
import Chartkick from 'vue-chartkick'
import Chartjs from 'chart.js'

//import Chart from '../charts.vue'
import DashBoard from '../components/dashboard.vue'

Vue.use(Chartkick.use(Chartjs))

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('dashboard'))
  new Vue({
    el,
    render: h => h(DashBoard)
  })
})
