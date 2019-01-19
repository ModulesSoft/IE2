<template>
    <div class="container">
        <navbar @username="setUser"></navbar>
        <router-view></router-view>
    </div>
</template>

<script>
    Vue.component('navbar', require('../components/Navbar.vue'));
    export default {
        name: "Layout",
        data(){
            return{
                username : ''
            }
        },
        methods:{
            setUser(username){
                this.username = username;
            }
        }
    }
</script>

<style scoped>

</style>