import Component from "@ember/component";
import { action } from "@ember/object";

export default Component.extend({
  @action
  revert(color) {
    color.revert();
  },

  @action
  undo(color) {
    color.undo();
  },
});
