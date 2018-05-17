import showModal from 'discourse/lib/show-modal';
import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

  model(params){
    var endpoint;
    if(params.theme_key){
      endpoint = `/theme/${params.theme_key}.json`;
    }else{
      endpoint = `/theme/${params.username}/${params.slug}.json`;
    }

    return ajax(endpoint).then((response)=>{
      return response['theme'];
    });
  },

  afterModel(model) {
    this.replaceWith('discovery.latest').then(() => {
      Ember.run.next(() => showModal('user-themes-view-modal', { model: model }));
    });

  },


});
