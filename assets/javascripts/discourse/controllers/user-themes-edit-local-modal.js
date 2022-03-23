import Controller from "@ember/controller";
import ModalFunctionality from "discourse/mixins/modal-functionality";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { action } from "@ember/object";

export default Controller.extend(ModalFunctionality, {
  @action
  showKey() {
    this.set("loading", true);

    ajax("/user_themes/fetch_api_key", {
      type: "POST",
    })
      .then((data) => {
        this.set("loading", false);
        this.set("model.apiKey", data["api_key"]);
      })
      .catch(popupAjaxError);
  },
});
