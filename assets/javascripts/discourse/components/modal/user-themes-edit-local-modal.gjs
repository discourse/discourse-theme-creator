import { tracked } from "@glimmer/tracking";
import Component from "@ember/component";
import { action } from "@ember/object";
import { htmlSafe } from "@ember/template";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";

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

  <template>
    <DModal
      id="theme-creator-edit-local-modal"
      @title={{i18n "theme_creator.edit_local"}}
      @closeModal={{@closeModal}}
    >
      <p>{{htmlSafe (i18n "theme_creator.edit_local_description")}}</p>

      <h3>{{i18n "theme_creator.edit_local_key"}}</h3>

      <ConditionalLoadingSpinner @condition={{this.loading}}>
        {{#if this.key}}
          <pre>{{this.key}}</pre>
        {{else}}
          <DButton
            @action={{this.showKey}}
            @icon="eye"
            @label="theme_creator.show_key"
          />
        {{/if}}
      </ConditionalLoadingSpinner>

      <p>{{htmlSafe (i18n "theme_creator.revoke_instructions")}}</p>
    </DModal>
  </template>
}
