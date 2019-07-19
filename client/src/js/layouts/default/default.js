import {mapGetters} from 'vuex';
import template from './default.pug';

export default Vue.extend({
  template: template({}),
  data() {
    return {
    };
  },
  computed: {
  },
  created() {
  },
  methods: {
    ...mapGetters([
      'user_name'
    ])
  }
});
