import Controller from "@ember/controller";
import getURL from "discourse-common/lib/get-url";
import ModalFunctionality from "discourse/mixins/modal-functionality";
import discourseComputed from "discourse-common/utils/decorators";
import { ajax } from "discourse/lib/ajax";
import { action } from "@ember/object";
import { next } from "@ember/runloop";

export default Controller.extend(ModalFunctionality, {
  @discourseComputed("model.id")
  postURL(id) {
    return getURL(`/user_themes/${id}/view`);
  },

  @action
  view() {
    if (!this.get("session.csrfToken")) {
      ajax(getURL("/session/csrf"), { cache: false }).then((result) => {
        this.set("session.csrfToken", result.csrf);
        next(() => $("#view-theme-form").submit());
      });
    } else {
      $("#view-theme-form").submit();
    }
  },

  @action
  download() {
    document.location = getURL(`/user_themes/${this.model.id}`);
  },

  @action
  cancel() {
    this.send("closeModal");
  },
});
