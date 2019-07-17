import template from './_form.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      title: '',
      content: ''
    };
  },
  methods: {
  }
});
