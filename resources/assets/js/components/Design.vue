<template>
    <div class="row">
        <div class="col-md-12 mt-2">
            Design new game:
        </div>
        <div class="col-md-6 mt-2">
            <div>enter name:</div>
            <input type="text" v-model="name"/>
        </div>
        <div class="col-md-6 mt-2">
            <div>enter maximun points:</div>
            <input type="number" v-model="max_point"/>
        </div>
        <div class="col-md-6">
            <div>enter dice number:</div>
            <input type="number" v-model="dice_number"/>
        </div>
        <div class="col-md-6">
            <div>enter maximum dice play number per each turn:</div>
            <input type="number" v-model="max_dice"/>
        </div>
        <div class="col-md-6">
            <div>enter zero current point :</div>
            <div>1<input type="checkbox" v-model="zero1"/></div>
            <div>2<input type="checkbox" v-model="zero2"/></div>
            <div>3<input type="checkbox" v-model="zero3"/></div>
            <div>4<input type="checkbox" v-model="zero4"/></div>
            <div>5<input type="checkbox" v-model="zero5"/></div>
            <div>6<input type="checkbox" v-model="zero6"/></div>
        </div>
        <div class="col-md-6"></div>
        <div class="col-md-6"></div>
        <div class="col-md-3 btn btn-primary" @click="send" style="width: 50px;height: 50px">submit</div>
    </div>
</template>

<script>
    export default {
        name: "Design",
        data() {
            return {
                max_point: null,
                dice_number: null,
                max_dice: null,
                name: null,
                zero1: 0,
                zero2: 0,
                zero3: 0,
                zero4: 0,
                zero5: 0,
                zero6: 0,
            }
        },
        methods: {
            send() {
                axios.post("/designGame", {
                    max_point: this.max_point,
                    dice_number: this.dice_number,
                    max_dice: this.max_dice,
                    name: this.name,
                    zero1: this.zero1,
                    zero2: this.zero2,
                    zero3: this.zero3,
                    zero4: this.zero4,
                    zero5: this.zero5,
                    zero6: this.zero5,
                    username: localStorage.username
                }).then(response => {
                    if (response.data == 'ok')
                        alert("ok")
                    else
                        alert("error")
                })
            }
        }
    }
</script>

<style scoped>

</style>