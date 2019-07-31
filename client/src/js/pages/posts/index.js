import jwt_decode from 'jwt-decode';
import ModalComponent from 'js/components/modal/index.js';
import template from './index.pug';

export default Vue.extend({
  template: template(),
  components: {
    ModalComponent
  },
  data() {
    return {
      posts: [],
      showModal: false,
      pagination: {
        currentPage: 1,
        limit: 3,
        totalElements: null
      },
      lastSort: {}
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
    async getPosts() {
      const {user_id} = jwt_decode(localStorage.getItem('token'));

      const result = await API.posts.index(
        {
          params: Object.assign({
            filter: {user_id},
            page: {size: this.pagination.limit, number: this.pagination.currentPage}
          },
          this.lastSort)
        }
      );

      this.pagination.totalElements = result.meta.total_count;
      this.posts = result.data;
    },

    changePage(page) {
      this.pagination.currentPage = page;
      this.getPosts();
    },

    changeLimit(limit) {
      this.pagination.limit = limit;
      this.pagination.currentPage = 1;
      this.getPosts();
    },

    async changeOrder(field, dir) {
      if (dir === 'desc') {
        this.lastSort = {sort: '-'.concat(field)};
      } else {
        this.lastSort = {sort: field};
      }

      this.getPosts();
    },

    async editPost(id) {
      this.$router.push({name: 'editPost', params: {id}});
    },

    async deletePost(id) {
      if (confirm('¿Realmente quiere eliminar este post?')) {
        await API.posts.destroy(id);

        this.getPosts();
      }
    },

    postClick(id) {
      id = id.toString();
      this.$router.push({name: 'post', params: {id}});
    }
  }
});
