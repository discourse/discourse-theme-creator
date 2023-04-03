import Controller from "@ember/controller";
import discourseComputed from "discourse-common/utils/decorators";

export default class UserThemes extends Controller {
  @discourseComputed("model", "model.@each.component")
  installedThemes(themes) {
    return themes.map((t) => t.name);
  }
}
