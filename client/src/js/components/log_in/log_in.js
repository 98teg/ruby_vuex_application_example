import {mapActions} from 'vuex';
import template from './log_in.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      user: '',
      password: '',
      has_to_login: true,
      has_to_logout: false,
      error: ''
    };
  },
  created() {
    if (localStorage.getItem('token') != null) {
      this.has_to_login = false;
      this.has_to_logout = true;
      this.set_current_user();
    }
  },
  methods: {
    ...mapActions([
      'set_current_user'
    ]),
    async login() {
      try {
        const session = await API.sessions
          .create({}, {params: {session: {email: this.user, password: this.password}}});

        this.has_to_login = false;
        this.has_to_logout = true;

        localStorage.setItem('token', session.jwt);
        this.set_current_user();
      } catch (error) {
        this.error = 'Error';
      }
    },
    logout() {
      this.has_to_login = true;
      this.has_to_logout = false;

      localStorage.removeItem('token');
    }
  }
});
