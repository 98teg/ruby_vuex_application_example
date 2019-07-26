export default {
  baseUrl: 'session',

  mergeOptions(options) {
    // definimos el resource que será utilizado en el intersector para traducir los errores
    const DEFAULT_OPTIONS = {resource: 'session'};
    return Object.assign({}, DEFAULT_OPTIONS, options);
  },

  create(session, options = {}) {
    return Vue.http.post(this.baseUrl, {session}, this.mergeOptions(options)).then(
      response => { if(response.ok) return response.body.session;
                    else return null;}
    );
  }
};