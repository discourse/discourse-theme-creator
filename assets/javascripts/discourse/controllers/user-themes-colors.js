import Controller from "@ember/controller";
import ThemesColors from "discourse/plugins/discourse-theme-creator/discourse/mixins/themes-colors";
import { alias } from "@ember/object/computed";
import { action } from "@ember/object";

export default class UserThemesColors extends Controller.extend(ThemesColors) {
  @alias("model.theme_id") id;
  @alias("model.colors") colors;

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
