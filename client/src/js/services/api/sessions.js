export default {
  baseUrl: 'http://localhost:3000/session',

  mergeOptions(options) {
    // definimos el resource que será utilizado en el intersector para traducir los errores
    const DEFAULT_OPTIONS = {resource: 'session'};
    return Object.assign({}, DEFAULT_OPTIONS, options);
  },

  create(data, options = {}) {
    const sendData = data instanceof FormData ? data : {data};

    return Vue.http.post(this.baseUrl, sendData, this.mergeOptions(options)).then(
      response => { if(response.ok) return response.body.session;
                    else return null;}
    );
  }
};