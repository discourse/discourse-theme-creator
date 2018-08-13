import ThemesColors from "discourse/plugins/discourse-theme-creator/discourse/mixins/themes-colors";

export default Ember.Controller.extend(ThemesColors, {
  id: Ember.computed.alias("model.theme_id"),
  colors: Ember.computed.alias("model.colors"),

  actions: {
    save() {
      this.set("isSaving", true);
      this.get("model")
        .save()
        .then(() => {
          this.set("isSaving", false);
        });
    }
  }
});
