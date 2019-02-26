import { default as computed } from "ember-addons/ember-computed-decorators";

export default Ember.Controller.extend({
  @computed("model", "model.@each.component")
  installedThemes(themes) {
    return themes.map(t => t.name);
  }
});
