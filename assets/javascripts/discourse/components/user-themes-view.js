import Component from "@glimmer/component";
import { action } from "@ember/object";
import { next } from "@ember/runloop";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import getURL from "discourse/lib/get-url";

export default class UserThemesViewModal extends Component {
  @service session;
  @service router;

  get postURL() {
    const { id } = this.args.model;
    return getURL(`/user_themes/${id}/view`);
  }

  @action
  async view() {
    if (!this.session.csrfToken) {
      const result = await ajax("/session/csrf");
      this.session.set("csrfToken", result.csrf);
      next(() => document.querySelector("#view-theme-form").submit());
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
