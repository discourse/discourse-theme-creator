import { default as computed } from "ember-addons/ember-computed-decorators";
import { url } from "discourse/lib/computed";

export default Ember.Mixin.create({
  previewUrl: url("id", "/user_themes/%@/preview"),

  @computed("isSaving")
  saveButtonText(isSaving) {
    return isSaving ? I18n.t("saving") : I18n.t("theme_creator.save");
  },

  @computed("colors.@each.changed")
  hidePreview(colors) {
    return colors && colors.some(color => color.get("changed"));
  }
});
