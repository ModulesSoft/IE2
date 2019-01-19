<template>
    <div class="row">
        <comments-modal :comments="commentsData" :design_id="design_id" v-if="commentsShow" @close="commentsShow = false"></comments-modal>
        <GameModal :id="gameId" v-if="gameShow" @close="gameShow=false"></GameModal>
        <div v-for="game in games" class="col-md-4">
            <div class="card" >
                <div class="card-body" @click="start(game.id)" style="cursor: pointer">
                    <h5 class="card-title">{{game.name}}</h5>
                    <p class="card-text">Design: {{game.username}} at {{game.created_at}}</p>
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">number of games: {{game.count}}</li>
                    <li class="list-group-item">number of online games: {{game.online}}</li>
                    <li class="list-group-item">average of points: {{game.average}}</li>
                </ul>
                <div class="card-body">
                    <div class="btn btn-primary" @click="comments(game.id)" style="width: 100%">comments</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Vue from 'vue'
    import GameModal from "./GameModal";
    Vue.component('CommentsModal', require('./CommentsModal.vue'));
    export default {
        name: "Start",
        components: {GameModal},
        data() {
            return {
                games: null,
                commentsData : null,
                commentsShow :false,
                gameShow: false,
                gameId:null,
                design_id : null
            }
        },
        mounted() {
            axios.get('/getGames').then(response => {
                this.games = response.data;
            })
        },
        methods: {
            comments(id) {
                this.design_id = id;
                axios.get('/getGamesComments/' + id).then(response => {
                    this.commentsData = response.data;
                    this.commentsShow = true;
                })
            },
            start(id){
                this.gameId = id
                this.gameShow= true
            }
        }
    }
</script>

<style scoped>

</style>