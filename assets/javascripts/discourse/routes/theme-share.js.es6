import showModal from 'discourse/lib/show-modal';
import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

  model(params){
    return ajax(`/user_themes/${params.id}/view.json`).then((response)=>{
      return response['theme'];
    });
  },

  afterModel(model, transition) {
    console.log("Model is", model);
    this.replaceWith('discovery.latest').then((e) => {
      Ember.run.next(() => showModal('user-themes-view-modal', { model: model }));
    });

  },


});
