import { url } from 'discourse/lib/computed';
import { default as computed } from 'ember-addons/ember-computed-decorators';
import { ajax } from 'discourse/lib/ajax';
import { popupAjaxError } from 'discourse/lib/ajax-error';

export default Ember.Controller.extend({
  previewUrl: url('model.id', `${location.protocol}//${location.host}${Discourse.getURL('/user_themes/%@/preview')}`),

  @computed('model.color_scheme_id')
  colorSchemeEditDisabled(colorSchemeId){
    return colorSchemeId === null;
  },

  @computed("colorSchemeId", "model.color_scheme_id")
  colorSchemeChanged(colorSchemeId, existingId) {
    colorSchemeId = colorSchemeId;
    return colorSchemeId !== existingId;
  },

  actions:{

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

    changeScheme(){
      this.get("model").set('color_scheme_id', this.get("colorSchemeId"));
      this.get("model").saveChanges("color_scheme_id");
    },
    cancelChangeScheme() {
      this.set("colorSchemeId", this.get("model.color_scheme_id"));
    },

    applyIsShared() {
      this.get("model").saveChanges("is_shared");
    },

    createColorScheme() {
      this.set('creatingColorScheme', true);

      const theme_id = this.get('model.id');
      ajax(`/user_themes/${theme_id}/colors`, {
        type: 'POST',
        data: {}
      }).then(()=>{
        this.set('creatingColorScheme', false);
        this.send("refreshThemes");
      }).catch(popupAjaxError);
    },

    destroyColorScheme() {
      this.get('colorSchemes').findBy('id', this.get('model.color_scheme_id')).destroy();
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
