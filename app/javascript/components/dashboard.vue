<template>
    <div>
        <div class="row">
            <temp-chart class="col-md-6" dt_type="temp"></temp-chart>
        </div>
        <div class="row">
            <humid-chart class="col-md-6" dt_type="humid"></humid-chart>
        </div>
    </div>
</template>

<script>
    import TempChart from '../components/tph_chart.vue';
    import HumidChart from '../components/tph_chart.vue';
    
    export default {
        components: {
            TempChart,
            HumidChart
        }
    };
</script>