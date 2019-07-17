import template from './show.pug';

export default Vue.extend({
  template: template(),
  props: {
    id: String
  },
  data() {
    return {
      title: '',
      content: ''
    };
  },
  async created() {
    const post = await API.posts.show(this.id);

    this.title = post.title;
    this.content = post.content;
  },
  methods: {
  }
});
