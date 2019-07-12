import ExampleComponent from 'js/components/example/index.js';

import template from './index.pug';

export default Vue.extend({
  template: template(),
  components: {
    ExampleComponent
  },
  data() {
    return {
    };
  },
  methods: {
  }
});
