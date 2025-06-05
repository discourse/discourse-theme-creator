import Component from "@ember/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { classNames, tagName } from "@ember-decorators/component";
import DButton from "discourse/components/d-button";
import TextField from "discourse/components/text-field";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

@tagName("div")
@classNames("metadata-field")
export default class ThemeMetadataField extends Component {
  value = null;
  oldValue = null;
  editing = false;

  @action
  startEditing(event) {
    event.preventDefault();
    this.set("oldValue", this.value);
    this.set("editing", true);
  }

  @action
  cancelEditing() {
    this.set("value", this.oldValue);
    this.set("editing", false);
  }

  @action
  async finishedEditing() {
    await this.save();
    this.set("editing", false);
  }

  <template>
    <span class="label">{{icon this.icon}} {{i18n this.label}}:</span>

    {{#if this.editing}}
      <TextField @value={{this.value}} @autofocus="true" />
      <DButton
        @action={{this.finishedEditing}}
        class="btn-primary btn-small submit-edit"
        @icon="check"
      />
      <DButton
        @action={{this.cancelEditing}}
        class="btn-small cancel-edit"
        @icon="xmark"
      />
    {{else}}
      {{#if this.value}}
        {{this.value}}
      {{else}}
        {{i18n "theme_creator.missing_metadata"}}
      {{/if}}

      <a href {{on "click" this.startEditing}}>{{icon "pencil"}}</a>
    {{/if}}
  </template>
}
