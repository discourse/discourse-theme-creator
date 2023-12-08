import Component from "@glimmer/component";
import getURL from "discourse-common/lib/get-url";
import { ajax } from "discourse/lib/ajax";
import { action } from "@ember/object";
import { next } from "@ember/runloop";
import { inject as service } from "@ember/service";

export default class UserThemesViewModal extends Component {
  @service session;
  @service router;

  get postURL() {
    const { id } = this.args.model;
    return getURL(`/user_themes/${id}/view`);
  }

  @action
  view() {
    if (!this.session.csrfToken) {
      ajax(getURL("/session/csrf"), { cache: false }).then((result) => {
        this.session.set("csrfToken", result.csrf);
        next(() => document.querySelector("#view-theme-form").submit());
      });
    } else {
      document.querySelector("#view-theme-form").submit();
    }
  }

  @action
  download() {
    document.location = getURL(`/user_themes/${this.args.model.id}`);
  }

  @action
  cancel() {
    this.router.transitionTo("/");
  }
}
