import { url } from 'discourse/lib/computed';
import { default as computed } from 'ember-addons/ember-computed-decorators';
import { ajax } from 'discourse/lib/ajax';
import { popupAjaxError } from 'discourse/lib/ajax-error';

export default Ember.Controller.extend({
  previewUrl: url('model.id', '/theme-creator/user_themes/%@/preview'),

  @computed('model.id', 'model.color_scheme.theme_id')
  canEditColorScheme(themeId, colorSchemeThemeId){
    return themeId === colorSchemeThemeId;
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

    applyIsShared() {
      this.get("model").saveChanges("is_shared");
    },

    createColorScheme() {
      const theme_id = this.get('model.id');
      ajax(`/theme-creator/user_themes/${theme_id}/colors`, {
        type: 'POST',
        data: {}
      }).then(()=>{
        this.send("refreshThemes");
      }).catch(popupAjaxError);
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
