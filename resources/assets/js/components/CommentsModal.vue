<template>
    <transition name="modal">
        <div class="modal-mask">
            <div class="modal-wrapper">
                <div class="modal-container">
                    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css"
                          integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ"
                          crossorigin="anonymous">
                    <div @click="$emit('close')" class="exit-btn"><i class="fa fa-times"></i></div>
                    <div class="row">
                        <div v-if="comments==''">
                            no comments
                        </div>
                        <div class="row" v-for="gc in comments">
                            <div class="col-md-4">
                                {{gc.username}}
                            </div>
                            <div class="col-md-4">
                                {{gc.text}}
                            </div>
                            <div class="col-md-4">
                                {{gc.created_at}}
                            </div>
                        </div>
                    </div>
                    <div style="padding: 10%">
                        <div :style="'color:'+errorColor">
                            {{error}}
                        </div>
                        <input type="text" placeholder="comment for the game" style="border-style: solid" v-model="commentText"></div>
                    <div class="btn btn-success" @click="submitComment">submit</div>
                </div>
                </div>
            </div>
        </div>
    </transition>
</template>

<script>
    export default {
        name: "CommentsModal",
        props: {comments: null,design_id:null},
        data() {
            return {
                commentText:'',
                error:'',
                errorColor:''
            }
        },
        mounted() {
            console.log(this.comments)
        },
        methods:{
            submitComment(){
                axios.post('/setGameComment',{
                    text: this.commentText,
                    username : localStorage.username,
                    design_id : this.design_id
                }).then(response=>{
                    if(response.data=='ok'){
                        this.error = 'comment sent!';
                        this.errorColor ="green";
                    }else{
                        this.error = 'comment not sent!';
                        this.errorColor ="red";
                    }
                })
            }
        }
    }
</script>

<style scoped>

    .modal-mask {
        position: fixed;
        z-index: 9998;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        display: table;
        transition: opacity 0.3s ease;
    }

    .modal-wrapper {
        display: table-cell;
        vertical-align: middle;
    }

    .modal-container {
        width: 500px;
        margin: 0px auto;
        padding: 20px 30px;
        background-color: #fff;
        border-radius: 2px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
        transition: all 0.3s ease;
    }

    .modal-header h3 {
        margin-top: 0;
        color: #42b983;
    }

    .modal-enter .modal-container,
    .modal-leave-active .modal-container {
        -webkit-transform: scale(1.1);
        transform: scale(1.1);
    }

    /*//////////////////////////////////////////////////////////////////
    [ FONT ]*/
    .exit-btn {
        float: right;
        cursor: pointer;
    }

</style>