import {mapActions} from 'vuex';
import template from './index.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      user: '',
      password: '',
      error: ''
    };
  },
  created() {
    if (localStorage.getItem('token') != null) {
      this.$router.push({name: 'home'});
    }
  },
  methods: {
    ...mapActions([
      'set_current_user'
    ]),
    async login() {
      try {
        const session = await API.sessions
          .create({email: this.user, password: this.password});

        localStorage.setItem('token', session.jwt);
        this.set_current_user();
        this.$router.push({name: 'home'});
      } catch (error) {
        this.error = error.body.errors.session[0].error;
      }
    }
  }
});
