import Component from "@ember/component";
import { action } from "@ember/object";
import { classNames, tagName } from "@ember-decorators/component";

@tagName("div")
@classNames("metadata-field")
export default class ThemeMetadataField extends Component {
  value = null;
  oldValue = null;
  editing = false;

  @action
  startEditing() {
    this.set("oldValue", this.value);
    this.set("editing", true);
  }

  @action
  cancelEditing() {
    this.set("value", this.oldValue);
    this.set("editing", false);
  }

  @action
  finishedEditing() {
    this.save().then(() => {
      this.set("editing", false);
    });
  }
}
