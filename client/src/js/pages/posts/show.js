import template from './show.pug';

export default Vue.extend({
  template: template(),
  props: {
    id: String
  },
  data() {
    return {
      post: '',
      hasImage: false,
      comment: '',
      wrongComment: false,
      commentsErrors: null
    };
  },
  async created() {
    this.post = await API.posts.show(this.id);
    if (this.post.image.url != null) this.hasImage = true;
  },
  methods: {
    async createComment() {
      try {
        const formData = new FormData();

        formData.append('data[content]', this.comment);
        formData.append('data[post_id]', this.id);

        await API.comments.create(formData);

        this.comment = '';
        this.wrongComment = false;
        this.commentsErrors = null;
      } catch (error) {
        if (error.body.content != null) {
          this.wrongComment = true;
          this.commentsErrors = error.body.content;
        } else {
          this.wrongComment = false;
          this.commentsErrors = null;
        }
      }
    },
    isLoged() {
      return localStorage.getItem('token') != null;
    }
  }
});
