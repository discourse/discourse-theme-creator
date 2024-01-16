import Mixin from "@ember/object/mixin";
import { url } from "discourse/lib/computed";
import discourseComputed from "discourse-common/utils/decorators";
import I18n from "I18n";

export default Mixin.create({
  previewUrl: url("id", "/user_themes/%@/preview"),

  @discourseComputed("isSaving")
  saveButtonText(isSaving) {
    return isSaving ? I18n.t("saving") : I18n.t("theme_creator.save");
  },

  @discourseComputed("colors.@each.changed")
  hidePreview(colors) {
    return colors && colors.some((color) => color.get("changed"));
  },
});
