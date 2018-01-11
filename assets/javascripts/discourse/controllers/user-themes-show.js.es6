import { url } from 'discourse/lib/computed';
import { default as computed } from 'ember-addons/ember-computed-decorators';

export default Ember.Controller.extend({
  previewUrl: url('model.id', '/theme-creator/user_themes/%@/preview'),

  @computed("model")
  editorId(model) {
    return  model.get('id') + "|scss|common";
  },

  @computed("model")
  activeSection: {
    get(model) {
      return model.getField('common', 'scss');
    },
    set(value, model) {
      model.setField('common', 'scss', value);
      return value;
    }
  },

  saveButtonText: function() {
    return this.get('model.isSaving') ? I18n.t('saving') : I18n.t('theme-creator.save');
  }.property('model.isSaving'),

  saveDisabled: function() {
    return !this.get('model.changed') || this.get('model.isSaving');
  }.property('model.changed', 'model.isSaving'),


  actions:{
    save() {
      this.set('saving', true);
      this.get('model').saveChanges("theme_fields").finally(()=>{this.set('saving', false);});
    },

    startEditingName() {
      this.set("oldName", this.get("model.name"));
      this.set("editingName", true);
    },
    cancelEditingName() {
      this.set("model.name", this.get("oldName"));
      this.set("editingName", false);
    },
    finishedEditingName() {
      this.get("model").saveChanges("name");
      this.set("editingName", false);
    },

    destroy() {
      return bootbox.confirm(I18n.t("theme-creator.delete_confirm"), I18n.t("no_value"), I18n.t("yes_value"), result => {
        if (result) {
          const model = this.get('model');
          model.destroyRecord().then(() => {
            this.get('allThemes').removeObject(model);
            this.transitionToRoute('user.themes');
          });
        }
      });
    },
  }

});
