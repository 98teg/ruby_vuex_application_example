import {mapGetters, mapActions} from 'vuex';
import template from './default.pug';

export default Vue.extend({
  template: template({}),
  data() {
    return {
      session: false
    };
  },
  computed: {
  },
  created() {
    if (localStorage.getItem('token') != null) {
      this.set_current_user();
      this.session = true;
    }
  },
  methods: {
    ...mapGetters([
      'user_name'
    ]),
    ...mapActions([
      'set_current_user'
    ]),
    logout() {
      localStorage.removeItem('token');
      this.session = false;
    }
  }
});
