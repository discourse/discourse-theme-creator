import Component from "@glimmer/component";
import { Input } from "@ember/component";
import { action } from "@ember/object";
import { next } from "@ember/runloop";
import { service } from "@ember/service";
import { or } from "truth-helpers";
import DButton from "discourse/components/d-button";
import avatar from "discourse/helpers/avatar";
import { ajax } from "discourse/lib/ajax";
import getURL from "discourse/lib/get-url";
import { i18n } from "discourse-i18n";

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

  <template>
    <div class="theme-creator-view-shared-theme">
      <h1>{{i18n "theme_creator.view_shared_theme"}}</h1>
      <h2>{{@model.name}}</h2>

      <p>
        {{avatar
          @model.user
          avatarTemplatePath="avatar_template"
          title=this.user.username
          imageSize="extra_large"
        }}
      </p>

      <h3>
        by
        {{or @model.user.name @model.user.username}}

      </h3>

      <p>{{i18n "theme_creator.view_shared_theme_education"}}</p>

      <p>
        <DButton class="btn-large" @action={{this.cancel}} @label="cancel" />

        <DButton
          class="btn-primary btn-large"
          @action={{this.view}}
          @label="theme_creator.view_theme"
        />
      </p>

      <form id="view-theme-form" method="post" action={{this.postURL}}>
        <Input
          @type="hidden"
          name="authenticity_token"
          id="authenticity_token"
          @value={{this.session.csrfToken}}
        />
      </form>
    </div>
  </template>
}
