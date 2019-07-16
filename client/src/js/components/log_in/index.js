import template from './index.pug';

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
    if (window.localStorage.getItem('token') != null) {
      this.has_to_login = false;
      this.has_to_logout = true;
    }
  },
  methods: {
    async login() {
      try {
        const {jwt} = await API.sessions
          .create({}, {params: {session: {email: this.user, password: this.password}}});

        this.has_to_login = false;
        this.has_to_logout = true;
        window.localStorage.setItem('token', jwt);
      } catch (error) {
        this.error = 'Error';
      }
    },
    logout() {
      this.has_to_login = true;
      this.has_to_logout = false;
      window.localStorage.removeItem('token');
    }
  }
});
