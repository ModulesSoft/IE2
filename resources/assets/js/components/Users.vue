<template>
    <div class="row mt-2">
        <div class="col-md-3" v-for="user in users" style="text-align: center">
            <router-link :to="'profile/'+user.username">
                <img :src="user.avatarURL" style="width: 200px;height: 200px;"/>
                <div>{{user.username}}</div>
            </router-link>
        </div>
    </div>
</template>

<script>
    export default {
        name: "Users",
        data() {
            return {
                users: null
            }
        },
        mounted() {
            axios.get('/getUsers').then(response =>
                this.users = response.data)
        }
    }
</script>

<style scoped>

</style>