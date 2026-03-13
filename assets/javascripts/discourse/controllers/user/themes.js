import Controller from "@ember/controller";
import { computed } from "@ember/object";

export default class UserThemes extends Controller {
  @computed("model", "model.@each.component")
  get installedThemes() {
    return this.model.map((t) => t.name);
  }
}
