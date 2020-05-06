<template>
        <div>
            <line-chart :data="tempData" :points="false" :xtitle="xtitle" :ytitle="ytitle" :min="ymin" />
        </div>
</template>

<script>
    import axios from 'axios';

    export default {
        props: {
            'dt_type': String
        },
        data: function() {
            return {
                tempData: [],
                tempOps: {},
                xtitle: '',
                ytitle: '',
                ymin: 0
            };
        },
        mounted() {
            this.fillData();
            this.fillOption();
        },
        methods: {
            fillData() {
                var api_url = '';
                switch (this.dt_type) {
                    case 'temp':
                        api_url = '/api/v1/ck_data/get_t_by_h?max=30';
                        break;
                    case 'humid':
                        api_url = '/api/v1/ck_data/get_h_by_h?max=30';
                        break;
                    default:
                        api_url = 'PLEASE SET dt_type.';
                }
                console.log('api_url => ' + api_url);
                
                axios
                    .get(api_url)
                    .then(resp => {
                        this.tempData = resp.data;
                        
                        var min_t = 100, max_t = -100;
                        resp.data.forEach(function(item) {
                            if (item.min < min_t) min_t = item.min;
                            if (max_t < item.max) max_t = item.max;
                        });
                        this.ymin = Math.floor(min_t / 10) * 10;
                    });
            },
            fillOption() {
                this.tempOps = {
                    legend: 'top',
                    points: false
                };
                
                this.xtitle = 'Datetime';
                
                switch (this.dt_type) {
                    case 'temp':
                        this.ytitle = 'Temp (C)';
                        break;
                    case 'humid':
                        this.ytitle = 'Humid (%)';
                        break;
                    default:
                        this.ytitle = 'PLEASE SET dt_type.';
                }
                console.log('ytitle => ' + this.ytitle);
            }
        }
    };
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
