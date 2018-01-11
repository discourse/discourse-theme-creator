import { popupAjaxError } from 'discourse/lib/ajax-error';

export default Discourse.Route.extend({
  model(){
    return this.store.findAll('user-theme');
  },

  actions:{
    addTheme(theme) {
      const all = this.modelFor('user.themes');
      all.pushObject(theme);
      this.transitionTo('user.themes.show', theme.get('id'));
    },

    newTheme(obj) {
      obj = obj || {name: I18n.t("theme-creator.new_theme_title")};
      const item = this.store.createRecord('user_theme');

      item.save(obj).then(() => {
        this.send('addTheme', item);
      }).catch(popupAjaxError);
    }
  }


});
