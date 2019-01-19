<template>
    <transition name="modal">
        <div class="modal-mask">
            <div class="modal-wrapper">
                <div class="modal-container">
                    <div class="limiter">
                        <div class="container-login100">
                            <div class="wrap-login100 p-t-50 p-b-90">
                                <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css"
                                      integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ"
                                      crossorigin="anonymous">
                                <div @click="exit" class="exit-btn"><i class="fa fa-times"></i></div>
                                <span class="login100-form-title p-b-51">
                                        Game
                                    </span>
                                <div :style="'color:'+errorColor">
                                    {{error}}
                                </div>
                                <div v-if="!finished">
                                    <div @click="rollDice"
                                         style="width: 100px;height: 100px;background-color: yellow; margin-left: 40%; padding:10% 10%;border-color: red;border-style:solid;cursor: pointer">
                                        {{dice}}
                                    </div>
                                    <div class="btn btn-success mb-2" style="margin-left: 45%;" @click="hold">hold</div>
                                    <div class="row" v-if="">
                                        <div class="col-md-6" style="background-color: silver">
                                            <div>{{username}}</div>
                                            <div>current : {{current}}</div>
                                            <div>global : {{global}}</div>
                                        </div>
                                        <div class="col-md-6">
                                            <div>{{competitor}}</div>
                                            <div>current : {{competitorCurrent}}</div>
                                            <div>global : {{competitorGlobal}}</div>
                                        </div>
                                    </div>
                                </div>
                                <div v-if="finished" style="padding: 20%">
                                    <input v-if="finished" type="text" placeholder="comment for the user" style="border-style: solid" v-model="commentText"></div>
                                    <div v-if="finished" class="btn btn-success" @click="submitComment">submit</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>
<script>
    import Vue from 'vue'

    export default {
        props: ["id"],
        data() {
            return {
                username: "",
                password: "",
                error: "",
                errorColor: "",
                sent: false,
                registerModalShown: false,
                competitor: null,
                gameId: null,
                cancel: false,
                dice: null,
                diceNumber: 1,
                maxPoint: 100,
                maxDice: 1,
                zero: [],
                diceCount: 0,
                current: 0,
                global:0,
                myTurn: false,
                competitorCurrent: null,
                competitorGlobal: null,
                imUser: null,
                finished: false,
                test: 0,
                commentText:''
            }
        },
        mounted() {
            this.username = localStorage.username
            // this.gameInitial();
            this.interval = setInterval(function () {
                if (!this.gameId) {
                    if (!this.cancel) {
                        this.gameInitial();
                    }
                } else {
                    if (!this.myTurn) {
                        this.competitorWatch();
                    }
                }
                if(this.finished){
                    window.clearInterval(this.interval);
                }
            }.bind(this), 2000);
        },
        methods: {
            submitComment(){
                axios.post('/setUserComment',{
                    text: this.commentText,
                    whom : this.competitor,
                    imUser: this.imUser
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
            ,rollDice() {
                if (this.myTurn) {
                    this.diceCount = this.diceCount +1
                    if (this.diceCount < this.maxDice) {
                        this.dice = Math.floor(Math.random() * 6) + 1;
                        if (this.zero[this.dice - 1] == 1) {
                            this.error = "your current will be 0 ;)"
                            this.current = 0
                        } else {
                            this.error = "hmm..."
                            this.current = this.current + this.dice;
                        }
                    }
                    else {
                        this.error = "max dice roll reached!"
                        this.diceCount = 0
                        this.play();
                    }
                }
            },
            hold() {
                if (this.myTurn) {
                    this.global = this.global + this.current;
                    this.current = 0;
                    this.diceCount = 0
                    this.play();
                }
            },
            play() {
                this.myTurn = false
                axios.post('/myMoves', {
                    username: this.username,
                    user: this.imUser,
                    current: this.current,
                    global: this.global,
                    gameId: this.gameId,
                    dice: this.dice
                }).then(response => {
                    if (response.data == 'ok') {
                        this.error = 'just Watch!'
                        this.errorColor = 'green'
                    }
                })
            },
            competitorWatch() {
                axios.post('/getMoves', {
                    username: this.username,
                    user: this.imUser,
                    gameId: this.gameId
                }).then(response => {
                    if (response.data.turn == this.imUser) {
                        this.myTurn = true;
                        this.error = "Your turn!"
                        this.errorColor = "green"
                    }
                    if (this.imUser == 1) {
                        this.dice = response.data.dice;
                        this.competitorCurrent = response.data.current2;
                        this.competitorGlobal = response.data.global2;
                        if (response.data.finished == 2) {
                            this.errorColor = "red"
                            this.error = "You lose!"
                            this.finished = true
                        }
                        if (response.data.finished == 1) {
                            this.errorColor = "green"
                            this.error = "You win!"
                            this.finished = true
                            axios.post('/editUser',{
                                username: localStorage.username,
                                point: 100
                            }).then(response=>{
                                if(response.data == 'ok'){
                                    alert('your points updated')
                                }
                            })
                        }
                    }
                    if (this.imUser == 2) {
                        this.dice = response.data.dice;
                        this.competitorCurrent = response.data.current1;
                        this.competitorGlobal = response.data.global1;
                        if (response.data.finished == 1) {
                            this.errorColor = "red"
                            this.error = "You lose!"
                            this.finished = true
                        }
                        if (response.data.finished == 2) {
                            this.errorColor = "green"
                            this.error = "You win!"
                            this.finished = true
                        }
                    }
                })
            },
            exit() {
                this.cancel = true
                window.clearInterval(this.interval);
                this.$emit('close')
            },
            gameInitial() {
                axios.post('/initialGame', {
                    username: localStorage.username,
                    id: this.id
                }).then(response => {
                    if (response.data == 'wait1') {
                        this.error = "waiting for competitor..."
                        this.errorColor = 'green'
                    } else if (response.data == 'wait2') {
                        this.error = "waitlisted!"
                        this.errorColor = "green"
                    } else if (response.data == 'cancel') {
                        this.error = "competitor not found try again later!"
                        this.errorColor = "red"
                        this.cancel = true
                    } else {
                        this.error = "game started. Wait for your turn" // + this.gameId;
                        this.errorColor = "green"
                        console.log(response.data)
                        if (response.data.user1 == localStorage.username) {
                            this.competitor = response.data.user2;
                            this.imUser = 1
                        }
                        else {
                            this.competitor = response.data.user1;
                            this.imUser = 2
                        }
                        this.diceNumber = response.data.dice_number
                        this.maxPoint = response.data.max_point
                        this.maxDice = response.data.max_dice
                        this.zero = [response.data.zero1, response.data.zero2, response.data.zero3, response.data.zero4, response.data.zero5, response.data.zero6]
                        this.gameId = response.data.id
                        // window.clearInterval(this.interval);
                    }
                })
            }
        }
    };
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
        width: 700px;
        height: 700px;
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

    /*---------------------------------------------*/
    a {
        font-size: 14px;
        line-height: 1.7;
        color: #666666;
        margin: 0px;
        transition: all 0.4s;
        -webkit-transition: all 0.4s;
        -o-transition: all 0.4s;
        -moz-transition: all 0.4s;
    }

    a:focus {
        outline: none !important;
    }

    a:hover {
        text-decoration: none;
        color: #403866;
    }

    /*---------------------------------------------*/
    h1,
    h2,
    h3,
    h4,
    h5,
    h6 {
        margin: 0px;
    }

    p {
        font-size: 10px;
        line-height: 1.7;
        color: #666666;
        margin: 0px;
    }

    ul,
    li {
        margin: 0px;
        list-style-type: none;
    }

    /*---------------------------------------------*/
    input {
        outline: none;
        border: none;
    }

    textarea {
        outline: none;
        border: none;
    }

    textarea:focus,
    input:focus {
        border-color: transparent !important;
    }

    input::-webkit-input-placeholder {
        color: #8f8fa1;
        font-size: 10px;
    }

    input:-moz-placeholder {
        color: #8f8fa1;
    }

    input::-moz-placeholder {
        color: #8f8fa1;
    }

    input:-ms-input-placeholder {
        color: #8f8fa1;
    }

    textarea::-webkit-input-placeholder {
        color: #8f8fa1;
    }

    textarea:-moz-placeholder {
        color: #8f8fa1;
    }

    textarea::-moz-placeholder {
        color: #8f8fa1;
    }

    textarea:-ms-input-placeholder {
        color: #8f8fa1;
    }

    label {
        display: block;
        margin: 0;
    }

    /*---------------------------------------------*/
    button {
        outline: none !important;
        border: none;
        background: transparent;
    }

    button:hover {
        cursor: pointer;
    }

    iframe {
        border: none !important;
    }

    /*//////////////////////////////////////////////////////////////////
    [ login ]*/

    .limiter {
        width: 100%;
        margin: 0 auto;
    }

    .container-login100 {
        width: 100%;
        /* min-height: 100vh; */
        display: -webkit-box;
        display: -webkit-flex;
        display: -moz-box;
        display: -ms-flexbox;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
        padding: 15px;

        background-position: center;
        background-size: cover;
        background-repeat: no-repeat;
    }

    .wrap-login100 {
        width: 390px;
        background: #fff;
        border-radius: 10px;
        position: relative;
    }

    .login100-form-title {
        font-size: 25px;
        color: #666666;
        line-height: 1.2;
        text-transform: uppercase;
        text-align: center;
        width: 100%;
        display: block;
        margin-bottom: 3vh;
    }

    .instruction {
        text-align: right;
        color: #827ffe;
        font-size: 1.7vh;
    }

    /*------------------------------------------------------------------
    [ Input ]*/

    .wrap-input100 {
        width: 100%;
        height: 6vh;
        position: relative;
        background-color: #e6e6e6;
        border: 1px solid transparent;
        border-radius: 100px;
    }

    /*---------------------------------------------*/
    .input100 {
        color: #403866;
        line-height: 1.2;
        font-size: 10px;

        display: block;
        width: 100%;
        background: transparent;
        height: 100%;
        padding: 0 20px 0 38px;
    }

    /*------------------------------------------------------------------
    [ Focus Input ]*/

    .focus-input100 {
        position: absolute;
        display: block;
        width: calc(100% + 2px);
        height: calc(100% + 2px);
        top: -1px;
        left: -1px;
        pointer-events: none;
        border: 1px solid #827ffe;
        border-radius: 30px;

        visibility: hidden;
        opacity: 0;

    }

    .input100:focus + .focus-input100 {
        visibility: visible;
        opacity: 1;

        -webkit-transform: scale(1);
        -moz-transform: scale(1);
        -ms-transform: scale(1);
        -o-transform: scale(1);
        transform: scale(1);
    }

    .input-checkbox100:checked + .label-checkbox100::before {
        color: #827ffe;
    }

    /*------------------------------------------------------------------
    [ Button ]*/
    .container-login100-form-btn {
        width: 50%;
        display: -webkit-box;
        display: -webkit-flex;
        display: -moz-box;
        display: -ms-flexbox;
        display: flex;
        flex-wrap: wrap;
        margin: 3vh 7vh 0 7vh;
    }

    .login100-form-btn {
        font-size: 16px;
        color: #fff;
        line-height: 1.2;
        text-transform: uppercase;

        display: -webkit-box;
        display: -webkit-flex;
        display: -moz-box;
        display: -ms-flexbox;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 20px;
        width: 100%;
        height: 6vh;
        background-color: #666666;
        border-radius: 30px;

        -webkit-transition: all 0.4s;
        -o-transition: all 0.4s;
        -moz-transition: all 0.4s;
        transition: all 0.4s;
    }

    .login100-form-btn:hover {
        background-color: #403866;
    }

    /*------------------------------------------------------------------
    [ Alert validate ]*/

    .validate-input {
        position: relative;
    }

    .alert-validate::before {
        content: attr(data-validate);
        position: absolute;
        max-width: 70%;
        background-color: #fff;
        border: 1px solid #c80000;
        border-radius: 3px;
        padding: 4px 25px 5px 10px;
        top: 50%;
        -webkit-transform: translateY(-50%);
        -moz-transform: translateY(-50%);
        -ms-transform: translateY(-50%);
        -o-transform: translateY(-50%);
        transform: translateY(-50%);
        right: 12px;
        pointer-events: none;

        font-family: Ubuntu-Regular;
        color: #c80000;
        font-size: 14px;
        line-height: 1.4;
        text-align: left;

        visibility: hidden;
        opacity: 0;

        -webkit-transition: opacity 0.4s;
        -o-transition: opacity 0.4s;
        -moz-transition: opacity 0.4s;
        transition: opacity 0.4s;
    }

    .alert-validate::after {
        content: "\f12a";
        font-family: FontAwesome;
        display: block;
        position: absolute;
        color: #c80000;
        font-size: 18px;
        top: 50%;
        -webkit-transform: translateY(-50%);
        -moz-transform: translateY(-50%);
        -ms-transform: translateY(-50%);
        -o-transform: translateY(-50%);
        transform: translateY(-50%);
        right: 18px;
    }

    .alert-validate:hover:before {
        visibility: visible;
        opacity: 1;
    }

    @media (max-width: 992px) {
        .alert-validate::before {
            visibility: visible;
            opacity: 1;
        }
    }

    /*//////////////////////////////////////////////////////////////////
    [ Responsive ]*/
</style>
