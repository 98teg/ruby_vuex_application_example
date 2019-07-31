import template from './index.pug';

export default Vue.extend({
  template: template(),
  props: {
    title: String,
    message: String
  }
});
