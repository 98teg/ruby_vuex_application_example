import template from './modal.pug';

export default Vue.extend({
  template: template(),
  props: {
    title: String,
    message: String
  }
});
