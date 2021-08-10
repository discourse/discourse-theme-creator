import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { url } from "discourse/lib/computed";

export default Ember.Mixin.create({
  previewUrl: url("id", "/user_themes/%@/preview"),

  @discourseComputed("isSaving")
  saveButtonText(isSaving) {
    return isSaving ? I18n.t("saving") : I18n.t("theme_creator.save");
  },

  @discourseComputed("colors.@each.changed")
  hidePreview(colors) {
    return colors && colors.some(color => color.get("changed"));
  }
});
