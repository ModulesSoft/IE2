<template>
    <div>
        <b-row>
            <div v-if="online">online</div>
            <div v-else>offline</div>
            <b-row>
                <div align="center" >
                    <div>{{ profile.username}} , points: {{profile.point}}</div>
                    <img :src="profile.avatarURL" class="avatarImage">
                    <div v-if="editable">
                        <div class="form-element" style="margin-NavBar: 90px">
                            old password<br>
                            <input type="password" v-model="pass0">
                        </div>
                        <div class="form-element" style="margin-NavBar: 10px;">
                            new password<br>
                            <input type="password" v-model="pass1">
                        </div>
                        <div class="form-element" style="margin-NavBar: 10px;">
                            repeat password<br>
                            <input type="password" v-model="pass2">
                        </div>
                        <button type="button" class="btn btn-info mt-5"
                                style="width:250px;border-radius: 30px;background-color: blue" @click="editUser()">
                            save
                        </button>
                        <div style="color:red;margin-NavBar: 10px">
                            {{error}}
                        </div>
                        <div style="color:green;margin-NavBar: 10px">
                            {{success}}
                        </div>
                    </div>
                </div>
            </b-row>
            <b-col>
                <div class="form-element">
                    Username<br>
                    <input type="text" disabled :value="profile.username">
                </div>
                <div class="form-element">
                    Name<br>
                    <input type="text" name="name" v-model="profile.name">
                </div>
                <div class="form-element">
                    email<br>
                    <input type="email" name="email" v-model="profile.email">
                </div>
            </b-col>
        </b-row>
        <div class="col-md-12">
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
    </div>
</template>

<script>
    import Vue from 'vue';

    export default {
        data() {
            return {
                pass0: '',
                pass1: '',
                pass2: '',
                success:'',
                username: '',
                error: '',
                profile: '',
                editable: false,
                online: false,
                comments: null
            }
        },
        mounted() {
            this.username = this.$route.params.username;
            axios.get('getUser/' + this.username)
                .then(response => {
                    this.profile = response.data
                    if (response.data.username == localStorage.username) {
                        this.editable = true;
                    }
                    axios.post('/getOnline', {username: response.data.username}).then(response => {
                        if (response.data.username)
                            this.online = response.data;
                    })
                })
            axios.post('/getMyComments', {
                username: this.username
            }).then(response => {
                this.comments = response.data;
            })
        },
        methods: {
            editUser() {
                if (this.pass1 || this.pass2) {
                    if (this.pass1 == this.pass2) {
                        axios.post('/editUser',
                            {
                                username: localStorage.username,
                                password: this.pass1,
                                name: this.profile.name,
                                email: this.profile.email,
                                // avatarURL: this.$session.getAll().user.avatarURL
                            }
                        ).then(response => {
                            if (response.data == 'ok') {
                                this.success = "password successfully changed!"
                            }
                            else {
                                this.error = "error with password change!"
                            }
                        })
                    } else {
                        this.error = "passwords don't match"
                    }
                }
            },
        }
    }
</script>

<style scoped>
    .avatarImage {
        width: 200px;
        height: 200px;
        border-radius: 100px;
        border-style: solid;
    }

    .form-element {
        text-align: right;
        float: right;
        display: inline-block;
        margin-right: 5%;
        font-size: 80%;
        color: blue;
    }

    .form-element input {
        border-radius: 20px;
        width: 300px;
        border-color: silver;
        border-style: solid;
        border-width: 1px;
        background-color: #DAE5F0;
        height: 30px;
        padding-right: 15px;
    / / padding-left: 15 px;
        direction: rtl;
    }

    .form-element textarea {
        border-radius: 20px;
        width: 650px;
        height: 150px;
        border-color: silver;
        border-style: solid;
        border-width: 1px;
        background-color: #DAE5F0;
        padding: 2%;
        margin: 2%;
        /*margin-bottom: 100px;*/
        resize: none;
        direction: rtl;
    }

    .contact-form button {
        border-radius: 20px;
        color: blue;
        border-style: solid;
        border-color: blue;
        width: 200px;
        height: 30px;
        background-color: white;
        border-width: 1px;
        margin-left: 8%;
        float: left;
        cursor: pointer;
    }

    .itemImage {
        float: right;
        width: 100px;
        height: 100px;
        border: solid 3px;
    }
</style>