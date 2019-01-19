<template>
    <div>
        <LoginModal v-if="loginModalShown" @close="loginModal" @usernameChanged="setUser" @user=""></LoginModal>
        <div style="padding:1% 1%;background-color:black">
            <div style="padding: 2% 1%;background-color:white">
                <div class="row" style="padding: 0 4%">
                    <div class="col-md-2">
                        <router-link to="/">Home</router-link>
                    </div>
                    <div v-if="!username" class="col-md-2" @click="loginModal" style="cursor: pointer;color: blue">
                        Profile
                    </div>
                    <div v-else class="col-md-2">
                        <router-link :to="'/profile/'+username">{{username}}</router-link>
                    </div>
                    <div class="col-md-2">
                        <router-link to="/start">Start Game</router-link>
                    </div>
                    <div class="col-md-2">
                        <router-link to="/design" v-if="username">Design Game</router-link>
                        <router-link to="" v-else>Design Game</router-link>
                    </div>
                    <div class="col-md-2">
                        <router-link to="/users">Users</router-link>
                    </div>
                    <div v-if="username" class="col-md-2" @click="logout" style="cursor: pointer">
                        Exit
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Vue from 'vue'
    // import {mapGetters} from 'vuex'

    Vue.component('LoginModal', require('./LoginModal.vue'));
    Vue.component('RegisterModal', require('./RegisterModal.vue'));
    export default {
        data() {
            return {
                loginModalShown: false,
                registerModalShown: false,
                username: null,
            };
        },
        mounted() {
            if (localStorage.username) {
                this.username = localStorage.username
            }
        },
        methods: {
            // menu(id){
            //     this.$emit('menu' , id)
            // },
            logout() {
                axios.post('/updateOnlines', {
                    'remove': this.username
                }).then()
                axios.get('/logout').then(response => {
                        if (response.data == 'ok') {
                            localStorage.clear()
                            this.username = null
                            alert('logged out')
                        }
                    }
                )
                localStorage.clear()
                this.$emit('username',null)
                window.location.href = '/';
            },
            loginModal() {
                this.loginModalShown = !this.loginModalShown;
            },
            setUser(username) {
                this.username = username
            }
            ,
            registerModal() {
                this.registerModalShown = !this.registerModalShown;
            }
        }
    }
</script>

<style scoped>

</style>