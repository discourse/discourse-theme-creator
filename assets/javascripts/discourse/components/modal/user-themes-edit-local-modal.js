import { tracked } from "@glimmer/tracking";
import Component from "@ember/component";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class UserThemesEditLocalModal extends Component {
  @tracked loading;
  @tracked key;

  @action
  async showKey() {
    this.loading = true;

    try {
      const data = await ajax("/user_themes/fetch_api_key", {
        type: "POST",
      });
      this.loading = false;
      this.key = data["api_key"];
    } catch (error) {
      return popupAjaxError(error);
    }
  }
}
