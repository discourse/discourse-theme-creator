import { default as computed } from 'ember-addons/ember-computed-decorators';
import { url } from 'discourse/lib/computed';

export default Ember.Controller.extend({
  previewUrl: url('model.id', '/theme-creator/user_themes/%@/preview'),

  @computed("fieldName", "targetName")
  editorId(fieldName, targetName) {
    return fieldName + "|" + targetName;
  },

  @computed("fieldName", "targetName", "model")
  activeSection: {
    get(fieldName, target, model) {
      return model.getField(target, fieldName);
    },
    set(value, fieldName, target, model) {
      model.setField(target, fieldName, value);
      return value;
    }
  },

  @computed("fieldName")
  activeSectionMode(fieldName) {
    return fieldName && fieldName.indexOf("scss") > -1 ? "scss" : "html";
  },

  @computed('model.changed', 'model.isSaving')
  saveDisabled(changed, saving) {
    return !changed || saving;
  },

  saveButtonText: function() {
    return this.get('model.isSaving') ? I18n.t('saving') : I18n.t('theme-creator.save');
  }.property('model.isSaving'),

  actions:{
    save() {
      this.set('saving', true);
      this.get('model').saveChanges("theme_fields").finally(()=>{this.set('saving', false);});
    },
  }

});
