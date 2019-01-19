<template>
    <div>
        <div class="row">
            Online Users:
            <ul>
                <li v-for="user in onlines">{{user.username}}</li>
            </ul>
        </div>
        <div v-if="username == 'admin'">
            Game Comments:
            <div class="row" v-for="gc in gamesComments">
                <div class="col-md-3">
                    {{gc.users_id}}
                </div>
                <div class="col-md-3">
                    {{gc.text}}
                </div>
                <div class="col-md-3">
                    {{gc.created_at}}
                </div>
                <div>
                    <button v-if="gc.confirmed==1" class="btn btn-success disabled">confirmed</button>
                    <button v-else @click="confirmGameComment(gc.id)" class="btn btn-success">confirm</button>
                </div>
            </div>
            User Comments:
            <div class="row" v-for="uc in usersComments">
                <div class="col-md-3">
                    {{uc.user_id}}
                </div>
                <div class="col-md-3">
                    {{uc.text}}
                </div>
                <div class="col-md-3">
                    {{uc.created_at}}
                </div>
                <div>
                    <button v-if="uc.confirmed==1" class="btn btn-success disabled">confirmed</button>
                    <button v-else @click="confirmUserComment(uc.id)" class="btn btn-success">confirm</button>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    export default {
        data() {
            return {
                onlines: '',
                username: null,
                usersComments: null,
                gamesComments: null
            }
        },
        mounted() {
            if (localStorage.username)
                this.username = localStorage.username
            else
                this.username = null

            this.loadData();
            this.interval = setInterval(function () {
                this.loadData();
            }.bind(this), 3000);
            this.fetchAdminData();
        }, methods: {
            loadData: function () {
                axios.get('/getOnlines').then(response => this.onlines = response.data)
            },
            fetchAdminData() {
                axios.get('/getGamesComments').then(response => {
                    this.gamesComments = response.data;
                })
                axios.get('/getUsersComments').then(response => {
                    this.usersComments = response.data;
                })
            },
            confirmGameComment(id) {
                axios.post('/confirmGameComment', {'id': id}).then(response => {
                    if (response.data == 'ok') {
                        this.fetchAdminData()
                    }
                    else {
                        alert('error')
                    }
                })
            },
            confirmUserComment(id) {
                axios.post('/confirmUserComment', {'id': id}).then(response => {
                    if (response.data == 'ok') {
                        this.fetchAdminData()
                    }
                    else {
                        alert('error')
                    }
                })
            }
        },
        beforeDestroy: function () {
            clearInterval(this.interval);
        }
    }
</script>
<style scoped>

</style>