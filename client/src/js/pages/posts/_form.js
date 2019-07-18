import template from './_form.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      title: '',
      content: '',
      image: null,
      wrongTitle: false,
      wrongContent: false,
      titleErrors: [],
      contentErrors: []
    };
  },
  methods: {
    processFile(event) {
      this.image = event.target.files[0];
    }
  }
});
