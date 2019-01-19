import Home from './components/Home.vue';
import Profile from './components/Profile.vue';
import Users from './components/Users.vue';
import Start from './components/Start.vue';
import Design from './components/Design.vue';


export const routes = [
    { path: '/', component: Home, name: 'home' },
    { path: '/profile/:username', component: Profile, name: 'profile' },
    { path: '/start', component: Start, name: 'start' },
    { path: '/design', component: Design, name: 'design' },
    { path: '/users', component: Users, name: 'users' },
    // { path: "*", component: PageNotFound }
];