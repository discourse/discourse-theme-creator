import Mixin from "@ember/object/mixin";
import { url } from "discourse/lib/computed";
import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

export default Mixin.create({
  previewUrl: url("id", "/user_themes/%@/preview"),

  @discourseComputed("isSaving")
  saveButtonText(isSaving) {
    return isSaving ? i18n("saving") : i18n("theme_creator.save");
  },

  @discourseComputed("colors.@each.changed")
  hidePreview(colors) {
    return colors && colors.some((color) => color.get("changed"));
  },
});
