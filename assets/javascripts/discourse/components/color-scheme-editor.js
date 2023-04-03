import Component from "@ember/component";
import { action } from "@ember/object";

export default class ColorSchemeEditor extends Component {
  @action
  revert(color) {
    color.revert();
  }

  @action
  undo(color) {
    color.undo();
  }
}
