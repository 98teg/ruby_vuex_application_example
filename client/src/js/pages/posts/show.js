import {mapGetters} from 'vuex';
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
      commentsErrors: null,
      comments: null
    };
  },
  async created() {
    this.post = await API.posts.show(this.id);
    if (this.post.image.url != null) this.hasImage = true;

    this.getComments();
  },
  methods: {
    ...mapGetters([
      'current_user',
      'user_roles'
    ]),
    async getComments() {
      const {data} = await API.comments.index({},
        {params: {sort: '-created_at', filter: {post_id: this.id}}});
      this.comments = data;
    },
    async createComment() {
      try {
        const formData = new FormData();

        formData.append('data[content]', this.comment);
        formData.append('data[post_id]', this.id);

        await API.comments.create(formData);

        this.comment = '';
        this.wrongComment = false;
        this.commentsErrors = null;

        this.getComments();
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
    },
    canDelete(id) {
      return this.user_roles().includes('admin') || this.current_user().id === id;
    },
    async deleteComment(id) {
      if (confirm('¿Realmente quiere eliminar este comentario?')) {
        await API.comments.destroy(id);

        this.getComments();
      }
    }
  }
});
