import { default as computed } from 'ember-addons/ember-computed-decorators';
import { url } from 'discourse/lib/computed';

export default Ember.Controller.extend({
  previewUrl: url('model.theme_id', '/theme-creator/user_themes/%@/preview'),

  @computed('isSaving')
  saveButtonText(isSaving) {
    return isSaving ? I18n.t('saving') : I18n.t('theme-creator.save');
  },

  actions:{
    revert(color) {
      color.revert();
    },

    undo(color) {
      color.undo();
    },

    save(){
      this.set('isSaving', true);
      this.get('model').save().then(()=>{
        this.set('isSaving', false);
      });
    }
  }

});
