import jwt_decode from 'jwt-decode';
import ModalComponent from 'js/components/modal/modal.js';
import template from './index.pug';

export default Vue.extend({
  template: template(),
  components: {
    ModalComponent
  },
  data() {
    return {
      posts: [],
      showModal: false
    };
  },
  async created() {
    if (localStorage.getItem('token') == null) {
      this.$router.push({name: 'home'});
    } else this.getPosts();
  },
  updated() {
    if (localStorage.getItem('token') == null) {
      this.$router.push({name: 'home'});
    }
  },
  methods: {
    async getPosts(options = {}) {
      const {user_id} = jwt_decode(localStorage.getItem('token'));
      const {data} = await API.posts.index({},
        {params: Object.assign({}, {filter: {user_id}}, options)});

      this.posts = data;
    },

    async orderByTitle() {
      this.getPosts({sort: 'title'});
    },

    async orderByDate() {
      this.getPosts({sort: '-created_at'});
    },

    async DeletePost(id) {
      await API.posts.destroy(id);

      this.getPosts();
    }
  }
});
