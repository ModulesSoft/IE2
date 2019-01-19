<template>
    <transition name="modal">
        <div class="modal-mask">
            <div class="modal-wrapper">
                <div class="wrap">
                    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css"
                          integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ"
                          crossorigin="anonymous">
                    <div @click="$emit('close')" class="exit-btn m-3"><i class="fa fa-times"></i></div>
                    <h1 class="register-title">Registeration</h1>
                    <div class="register">
                        <input type="text" v-model="name" class="register-input" placeholder="name">
                        <input type="email" v-model="email" class="register-input" placeholder="email">
                        <input type="text" v-model="username" class="register-input" placeholder="username">
                        <input type="text" v-model="avatarURL" class="register-input"
                               placeholder="avatar url (not required)">
                        <input type="password" v-model="password1" class="register-input" placeholder="password">
                        <input type="password" v-model="password2" class="register-input" placeholder="password again">
                        <div style="font-size:80%" v-bind:style="{color: errorColor}" align="right">{{error}}</div>
                        <button v-if="!sent" @click="postRegister" class="register-button">register</button>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>
<script>
    export default {
        props: ["close"],
        data() {
            return {
                email: "",
                name: "",
                username: "",
                password1: "",
                password2: "",
                avatarURL: "",
                error: "",
                errorColor: "",
                sent: false
            }
        },
        mounted() {
        },
        methods: {
            postRegister(response) {
                if (this.name == '') {
                    this.error = "username required";
                    this.errorColor = 'red';
                    return null
                }
                if (this.email == '') {
                    this.error = "email required";
                    this.errorColor = 'red';
                    return null
                }
                if (this.password1 != this.password2) {
                    this.error = "passwords not matching";
                    this.errorColor = 'red';
                    return null
                }
                if (this.password1 == '') {
                    this.error = "password required";
                    this.errorColor = 'red';
                    return null
                }
                if (!this.validateEmail(this.email)) {
                    this.error = "email required";
                    this.errorColor = 'red';
                    return null
                }
                this.loginError = false;
                this.sent = true;
                axios.post('/setUser', {
                    avatarURL: this.avatarURL,
                    email: this.email,
                    password: this.password1,
                    name: this.name,
                    username: this.username
                }).then(response => {
                    // localStorage.removeItem('token')
                    if (response.data == 'nok1') {
                        this.error = "password required";
                        this.errorColor = 'red'
                        return null
                    }
                    if (response.data == 'nok2') {
                        this.error = "username required";
                        this.errorColor = 'red'
                        return null
                    }

                    if (response.data == 'ok') {
                        this.errorColor = 'green'
                        this.error = "registered successfully";
                        return null
                    }
                    // this.error = response.data;
                    // store.commit('loginUser')
                    // localStorage.token = response.data.access_token
                    // localStorage.username = this.username
                    // this.$emit('usernameChanged', this.username)
                    // this.$emit('close')
                }).catch(error => {
                    console.error(error)
                    this.error = this.feeder.error8;
                    this.errorColor = 'red'
                });

            }
            ,
            validateEmail(email) {
                var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                return re.test(String(email).toLowerCase());
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
        width: 300px;
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

    body {
        font-family: "Raleway", Helvetica, sans-serif;
        font-size: 14px;
        color: #404040;
        background: #272727;
    }

    .wrap {
        margin: auto;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 300px;
        height: 100%;
        text-align: center;
    }

    .register-title {
        margin-top: 0;
        padding: 10px;
        width: 300px;
        line-height: 43px;
        font-size: 19px;
        font-weight: 500;
        color: #EEEEEE;
        text-align: center;
        text-shadow: 0 1px rgba(0, 0, 0, 0.3);
        background: #d7604b;
        border-radius: 3px;
        background-color: #3290B1;
        box-shadow: inset 0 1px rgba(255, 255, 255, 0.1), inset 0 0 0 1px rgba(255, 255, 255, 0.05), 0 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.3);
    }

    .register {
        margin: 0 auto;
        width: 300px;
        padding: 40px;
        background: #f4f4f4;
        border-radius: 3px;
        -webkit-box-shadow: 0 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.3);
        box-shadow: 0 0 1px 1px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.3);
    }

    input {
        font-family: inherit;
        font-size: inherit;
        color: inherit;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
    }

    .register-input {
        display: block;
        width: 100%;
        height: 38px;
        margin-top: 2px;
        font-weight: 500;
        background: none;
        border: 0;
        border-bottom: 1px solid #d8d8d8;
        pading: 10px;
    }

    .register-input:focus {
        border-color: #1e9ce6;
        outline: 0;
    }

    .register-button {
        display: block;
        width: 100%;
        height: 42px;
        margin-top: 25px;
        font-size: 16px;
        font-weight: bold;
        color: #494d59;
        text-align: center;
        text-shadow: 0 1px rgba(255, 255, 255, 0.5);
        background: #fcfcfc;
        border: 1px solid;
        border-color: #d8d8d8 #d1d1d1 #c3c3c3;
        border-radius: 2px;
        cursor: pointer;
        background-image: -webkit-linear-gradient(top, #fefefe, #eeeeee);
        background-image: -moz-linear-gradient(top, #fefefe, #eeeeee);
        background-image: -o-linear-gradient(top, #fefefe, #eeeeee);
        background-image: linear-gradient(to bottom, #fefefe, #eeeeee);
        -webkit-box-shadow: inset 0 -1px rgba(0, 0, 0, 0.03), 0 1px rgba(0, 0, 0, 0.04);
        box-shadow: inset 0 -1px rgba(0, 0, 0, 0.03), 0 1px rgba(0, 0, 0, 0.04);
    }

    .register-button:active {
        background: #eee;
        border-color: #c3c3c3 #d1d1d1 #d8d8d8;
        background-image: -webkit-linear-gradient(top, #eeeeee, #fcfcfc);
        background-image: -moz-linear-gradient(top, #eeeeee, #fcfcfc);
        background-image: -o-linear-gradient(top, #eeeeee, #fcfcfc);
        background-image: linear-gradient(to bottom, #eeeeee, #fcfcfc);
        -webkit-box-shadow: inset 0 1px rgba(0, 0, 0, 0.03);
        box-shadow: inset 0 1px rgba(0, 0, 0, 0.03);
    }

    .register-button:focus {
        outline: 0;
    }

    .register-switch {
        height: 32px;
        margin-bottom: 15px;
        padding: 4px;
        background: #6db244;
        border-radius: 2px;
        background-color: #78A781;
        -webkit-box-shadow: inset 0 1px rgba(0, 0, 0, 0.05), inset 1px 0 rgba(0, 0, 0, 0.02), inset -1px 0 rgba(0, 0, 0, 0.02);
        box-shadow: inset 0 1px rgba(0, 0, 0, 0.05), inset 1px 0 rgba(0, 0, 0, 0.02), inset -1px 0 rgba(0, 0, 0, 0.02);
    }

    .register-switch-input {
        display: none;
    }

    .register-switch-label {
        float: left;
        width: 50%;
        line-height: 32px;
        color: white;
        text-align: center;
        text-shadow: 0 -1px rgba(0, 0, 0, 0.2);
        cursor: pointer;
    }

    .register-switch-input:checked + .register-switch-label {
        font-weight: 500;
        color: #434248;
        text-shadow: 0 1px rgba(255, 255, 255, 0.5);
        background: white;
        border-radius: 2px;
        background-image: -webkit-linear-gradient(top, #fefefe, #eeeeee);
        background-image: -moz-linear-gradient(top, #fefefe, #eeeeee);
        background-image: -o-linear-gradient(top, #fefefe, #eeeeee);
        background-image: linear-gradient(to bottom, #fefefe, #eeeeee);
        -webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(0, 0, 0, 0.1);
        box-shadow: 0 1px 1px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(0, 0, 0, 0.1);
    }

    :-moz-placeholder {
        color: #aaa;
        font-weight: 300;
    }

    ::-moz-placeholder {
        color: #aaa;
        font-weight: 300;
        opacity: 1;
    }

    ::-webkit-input-placeholder {
        color: #aaa;
        font-weight: 300;
    }

    :-ms-input-placeholder {
        color: #aaa;
        font-weight: 300;
    }

    ::-moz-focus-inner {
        border: 0;
        padding: 0;
    }
</style>
