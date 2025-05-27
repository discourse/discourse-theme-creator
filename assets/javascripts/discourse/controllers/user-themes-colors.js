import Controller from "@ember/controller";
import { action } from "@ember/object";
import { alias } from "@ember/object/computed";
import { url } from "discourse/lib/computed";
import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

export default class UserThemesColors extends Controller {
  @alias("model.theme_id") id;
  @alias("model.colors") colors;
  @url("id", "/user_themes/%@/preview") previewUrl;

  @discourseComputed("isSaving")
  saveButtonText(isSaving) {
    return isSaving ? i18n("saving") : i18n("theme_creator.save");
  }

  @discourseComputed("colors.@each.changed")
  hidePreview(colors) {
    return colors && colors.some((color) => color.get("changed"));
  }

  @action
  save() {
    this.set("isSaving", true);
    this.get("model")
      .save()
      .then(() => {
        this.set("isSaving", false);
      });
  }
}
