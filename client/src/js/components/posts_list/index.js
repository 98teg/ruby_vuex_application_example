import template from './index.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      filterTitle: '',
      filterContent: '',
      filterUserID: '',
      filterSince: '',
      filterUntil: '',
      lastSort: {},
      posts: []
    };
  },
  async created() {
    const {data} = await API.posts.index();

    this.posts = data;
  },
  methods: {
    getFilters() {
      let filter = {};

      if (this.filterTitle !== '') {
        filter = Object.assign({}, filter, {title: this.filterTitle});
      }
      if (this.filterContent !== '') {
        filter = Object.assign({}, filter, {content: this.filterContent});
      }
      if (this.filterUserID !== '') {
        filter = Object.assign({}, filter, {user_id: this.filterUserID});
      }
      if (this.filterSince !== '') {
        filter = Object.assign({}, filter, {since: this.filterSince});
      }
      if (this.filterUntil !== '') {
        filter = Object.assign({}, filter, {until: this.filterUntil});
      }

      const filtro = {
        fitler: filter
      };

      return filtro;
    },
    getParams(params) {
      return Object.assign({}, this.getFilters(), params);
    },
    async getPosts() {
      const {data} = await API.posts.index({}, {params: this.getParams(this.lastSort)});

      this.posts = data;
    },
    async orderByTitle() {
      this.lastSort = {sort: 'title'};

      this.getPosts();
    },
    async orderByDate() {
      this.lastSort = {sort: '-created_at'};

      this.getPosts();
    },
    async orderByAuthor() {
      this.lastSort = {sort: 'user_name'};

      this.getPosts();
    }
  }
});
