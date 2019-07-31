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
      pagination: {
        currentPage: 1,
        limit: 3,
        totalElements: null
      },
      posts: []
    };
  },
  async created() {
    this.getPosts();
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
        filter
      };

      return filtro;
    },
    getParams(params) {
      const temp = Object.assign({}, this.getFilters(), params);
      return Object.assign({},
        {page: {size: this.pagination.limit, number: this.pagination.currentPage}}, temp);
    },
    async getPosts() {
      const result = await API.posts.index({params: this.getParams(this.lastSort)});

      this.posts = result.data;
      this.pagination.totalElements = result.meta.total_count;
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
    postClick(id) {
      id = id.toString();
      this.$router.push({name: 'post', params: {id}});
    }
  }
});
